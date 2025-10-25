/**
 * Ti.SPM
 * Copyright TiDev, Inc. 04/07/2022-Present. All Rights Reserved.
 * All Rights Reserved.
 */

'use strict';

exports.id = 'ti.spm';
exports.cliVersion = '>=3.2';
exports.init = init;

/**
 * A function to inject SPM packages into the Xcode project.
 * The 24 char UUIDs should be random.
 * Each UUID should be uppercase (by convention) and each of the 3 UUID params unique.
 *
 * @param {Object} xobjs - the Xcode plist object graph
 * @param {Object} config Swift package configuration.
 * @param {String} config.remotePackageReference Swift package remote package reference name, e.g. MyPackage-iOS.
 * @param {String} config.repositoryURL SPM repository URL, e.g. https://github.com/some-company/MyPackage-iOS.
 * @param {String} config.requirementKind SPM repository kind, e.g. upToNextMajorVersion.
 * @param {String} config.requirementMinimumVersion SPM repository minimum version, e.g. 3.0.0.
 * @param {Array<Object>} config.products Swift package product configurations.
 * @param {String} config.products[].productName Swift package product name, e.g. MyPackageKit.
 * @param {String} [config.products[].frameworkName] Optional framework name for comments, defaults to product name.
 *
 */
function injectSPMPackage(xobjs, config) {
	if (!xobjs || typeof xobjs !== 'object') {
		return;
	}

	const {
		remotePackageReference,
		repositoryURL,
		requirementKind,
		requirementMinimumVersion,
		products
	} = config;

	xobjs.PBXBuildFile = xobjs.PBXBuildFile || {};
	xobjs.PBXFrameworksBuildPhase = xobjs.PBXFrameworksBuildPhase || {};
	xobjs.PBXNativeTarget = xobjs.PBXNativeTarget || {};
	xobjs.PBXProject = xobjs.PBXProject || {};

	const remoteReferenceKey = ensureRemotePackageReference(xobjs, {
		remotePackageReference,
		repositoryURL,
		requirementKind,
		requirementMinimumVersion
	});

	Object.keys(xobjs.PBXProject).forEach(function (pbxProjUUID) {
		var pbxProj = xobjs.PBXProject[pbxProjUUID];
		if (pbxProj && typeof pbxProj === 'object') {
			pbxProj["packageReferences"] = updatePBXList(
				pbxProj["packageReferences"],
				[remoteReferenceKey]
			);
		}
	});

	var packageProductDependencyEntries = [];
	var nonStaticTargets = getNonStaticLibraryTargets(xobjs);
	var frameworkPhaseKeys = getFrameworkPhaseKeys(xobjs, nonStaticTargets);

	products.forEach(function (productConfig) {
		var productDependency = ensureProductDependency(xobjs, remoteReferenceKey, productConfig);
		packageProductDependencyEntries.push(productDependency.key);

		var buildFile = ensureFrameworkBuildFile(xobjs, productDependency.uuid, productConfig);

		frameworkPhaseKeys.forEach(function (phaseKey) {
			var buildPhase = xobjs.PBXFrameworksBuildPhase[phaseKey];
			ensureBuildPhaseHasFile(buildPhase, buildFile.uuid, buildFile.comment);
		});
	});

	nonStaticTargets.forEach(function (targetInfo) {
		var nativeTarget = targetInfo.target;
		if (nativeTarget && typeof nativeTarget === 'object') {
			nativeTarget["packageProductDependencies"] = updatePBXList(
				nativeTarget["packageProductDependencies"],
				packageProductDependencyEntries
			);
		}
	});
}

function ensureRemotePackageReference(xobjs, config) {
	xobjs.XCRemoteSwiftPackageReference = xobjs.XCRemoteSwiftPackageReference || {};
	var remoteRefs = xobjs.XCRemoteSwiftPackageReference;
	var repositoryURL = config.repositoryURL;
	var requirementKind = config.requirementKind;
	var minimumVersion = config.requirementMinimumVersion;

	var existingKey = Object.keys(remoteRefs).find(function (key) {
		var entry = remoteRefs[key];
		if (!entry || typeof entry !== 'object') {
			return false;
		}
		var repo = stripQuotes(entry.repositoryURL);
		return repo === repositoryURL;
	});

	if (existingKey) {
		var existingEntry = remoteRefs[existingKey];
		existingEntry.repositoryURL = "\"" + repositoryURL + "\"";
		existingEntry.requirement = {
			"kind":requirementKind,
			"minimumVersion":minimumVersion
		};
		return existingKey;
	}

	var spmRemotePackageUUID = generateUUID24();
	var remoteReferenceKey = spmRemotePackageUUID +
		" \/* XCRemoteSwiftPackageReference \"" +
		config.remotePackageReference + "\" *\/";

	remoteRefs[remoteReferenceKey] = {
		"isa":"XCRemoteSwiftPackageReference",
		"repositoryURL":"\"" + repositoryURL + "\"",
		"requirement":{
			"kind":requirementKind,
			"minimumVersion":minimumVersion
		}
	};

	return remoteReferenceKey;
}

/**
 * Main entry point for our plugin which looks for the platform specific
 * plugin to invoke.
 *
 * @param {Object} logger The logger instance.
 * @param {Object} config The hook config.
 * @param {Object} cli The Titanium CLI instance.
 * @param {Object} appc The Appcelerator CLI instance.
 */
// eslint-disable-next-line no-unused-vars
function init(logger, config, cli) {
	cli.on('build.ios.xcodeproject', {
		pre: function (data) {

			var xobjs = data.args[0].hash.project.objects;

			injectSPMPackage(xobjs, {
				remotePackageReference: "Parse-SDK-iOS-OSX",
				repositoryURL: "https://github.com/parse-community/Parse-SDK-iOS-OSX",
				requirementKind: "upToNextMajorVersion",
				requirementMinimumVersion: "5.1.1",
				products: [
					{
						frameworkName: "ParseLiveQuery",
						productName: "ParseLiveQuery"
					},
					{
						frameworkName: "ParseObjC",
						productName: "ParseObjC"
					}
				]
			});
		}
	});
}

function generateUUID24() {
    let chars = '0123456789ABCDEF'; // hexadecimal characters
    let uuid = '';

    for (let i = 0; i < 24; i++) {
        let randomIndex = Math.floor(Math.random() * chars.length);
        uuid += chars[randomIndex];
    }

    return uuid;
}

function updatePBXList(existingList, additions) {
	const items = parsePBXList(existingList);

	additions.forEach(function (item) {
		if (items.indexOf(item) === -1) {
			items.push(item);
		}
	});

	return formatPBXList(items);
}

function parsePBXList(listString) {
	if (Array.isArray(listString)) {
		return listString.map(function (entry) {
			if (typeof entry === 'string') {
				return entry.trim();
			}
			if (entry && typeof entry === 'object' && entry.value) {
				var commentSegment = entry.comment ? " \/* " + entry.comment + " *\/" : "";
				return entry.value + commentSegment;
			}
			return null;
		}).filter(Boolean);
	}

	if (typeof listString !== 'string') {
		return [];
	}

	return listString
		.replace(/[()]/g, '')
		.split(',')
		.map(function (entry) {
			return entry.trim();
		})
		.filter(function (entry) {
			return entry.length > 0;
		});
}

function formatPBXList(items) {
	if (!items || !items.length) {
		return "(\n\t\t\t)";
	}

	return "(\n" + items.map(function (entry) {
		return "\t\t\t\t" + entry + ",";
	}).join("\n") + "\n\t\t\t)";
}

function ensureProductDependency(xobjs, remoteReferenceKey, productConfig) {
	xobjs.XCSwiftPackageProductDependency = xobjs.XCSwiftPackageProductDependency || {};
	var dependencies = xobjs.XCSwiftPackageProductDependency;
	var productName = productConfig.productName;

	var existingKey = Object.keys(dependencies).find(function (key) {
		var entry = dependencies[key];
		return entry && entry.productName === productName;
	});

	if (existingKey) {
		var existingEntry = dependencies[existingKey];
		existingEntry.package = remoteReferenceKey;
		return {
			key: existingKey,
			uuid: extractUUID(existingKey)
		};
	}

	var swiftProductUUID = generateUUID24();
	var productDependencyKey = swiftProductUUID + " \/* " +
		productName + " *\/";

	dependencies[productDependencyKey] = {
		"isa":"XCSwiftPackageProductDependency",
		"package":remoteReferenceKey,
		"productName":productName
	};

	return {
		key: productDependencyKey,
		uuid: swiftProductUUID
	};
}

function ensureFrameworkBuildFile(xobjs, swiftProductUUID, productConfig) {
	var frameworkName = productConfig.frameworkName || productConfig.productName;
	var comment = frameworkName + " in Frameworks";
	var productName = productConfig.productName;

	xobjs.PBXBuildFile = xobjs.PBXBuildFile || {};
	var buildFiles = xobjs.PBXBuildFile;

	var existingKey = Object.keys(buildFiles).find(function (key) {
		return key && key.indexOf(comment) !== -1;
	});

	if (existingKey) {
		var existingEntry = buildFiles[existingKey];
		existingEntry.productRef = swiftProductUUID;
		existingEntry.fileRef_comment = productName + " in Frameworks";
		return {
			key: existingKey,
			uuid: extractUUID(existingKey),
			comment: comment
		};
	}

	var pbxBuildFileUUID = generateUUID24();
	var buildFileKey = pbxBuildFileUUID + " \/* " +
		comment + " *\/";

	buildFiles[buildFileKey] = {
		"isa":"PBXBuildFile",
		"productRef":swiftProductUUID,
		"fileRef_comment":productName + " in Frameworks"
	};

	return {
		key: buildFileKey,
		uuid: pbxBuildFileUUID,
		comment: comment
	};
}

function ensureBuildPhaseHasFile(buildPhase, pbxBuildFileUUID, comment) {
	if (!buildPhase || typeof buildPhase !== 'object') {
		return;
	}

	buildPhase.files = buildPhase.files || [];

	var updated = false;

	buildPhase.files.forEach(function (fileEntry) {
		if (!fileEntry || typeof fileEntry !== 'object') {
			return;
		}
		if (fileEntry.comment === comment || fileEntry.value === pbxBuildFileUUID) {
			fileEntry.value = pbxBuildFileUUID;
			fileEntry.comment = comment;
			updated = true;
		}
	});

	if (!updated) {
		buildPhase.files.push({
			"value":pbxBuildFileUUID,
			"comment":comment
		});
	}
}

function getNonStaticLibraryTargets(xobjs) {
	var targets = [];

	Object.keys(xobjs.PBXNativeTarget || {}).forEach(function (targetKey) {
		var target = xobjs.PBXNativeTarget[targetKey];
		if (!target || typeof target !== 'object') {
			return;
		}

		var productType = target.productType || '';
		if (productType.indexOf('library.static') !== -1) {
			return;
		}

		targets.push({
			key: targetKey,
			uuid: extractUUID(targetKey),
			target: target
		});
	});

	return targets;
}

function getFrameworkPhaseKeys(xobjs, targetInfos) {
	var frameworkPhaseKeys = [];
	var frameworkPhaseSet = new Set();

	targetInfos.forEach(function (info) {
		var target = info.target;
		var buildPhases = listFromPBXValue(target.buildPhases);

		buildPhases.forEach(function (phaseRef) {
			var phaseUUID = extractUUID(phaseRef);
			var phaseKey = findFrameworkPhaseKey(xobjs, phaseUUID);

			if (phaseKey && !frameworkPhaseSet.has(phaseKey)) {
				frameworkPhaseSet.add(phaseKey);
				frameworkPhaseKeys.push(phaseKey);
			}
		});
	});

	return frameworkPhaseKeys;
}

function listFromPBXValue(value) {
	if (!value) {
		return [];
	}

	if (Array.isArray(value)) {
		return value.map(function (entry) {
			if (typeof entry === 'string') {
				return entry.trim();
			}
			if (entry && typeof entry === 'object' && entry.value) {
				var commentSegment = entry.comment ? " \/* " + entry.comment + " *\/" : "";
				return entry.value + commentSegment;
			}
			return null;
		}).filter(Boolean);
	}

	if (typeof value === 'string') {
		return parsePBXList(value);
	}

	return [];
}

function findFrameworkPhaseKey(xobjs, phaseUUID) {
	if (!phaseUUID) {
		return null;
	}

	var keys = Object.keys(xobjs.PBXFrameworksBuildPhase || {});

	for (var i = 0; i < keys.length; i++) {
		var key = keys[i];
		if (extractUUID(key) === phaseUUID) {
			return key;
		}
	}

	return null;
}

function extractUUID(reference) {
	if (!reference || typeof reference !== 'string') {
		return reference;
	}

	var spaceIndex = reference.indexOf(' ');
	if (spaceIndex === -1) {
		return reference;
	}

	return reference.substring(0, spaceIndex);
}

function stripQuotes(value) {
	if (typeof value !== 'string') {
		return value;
	}

	return value.replace(/^"+|"+$/g, '');
}
