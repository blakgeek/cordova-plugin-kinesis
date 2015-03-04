

function KinesisPlugin() {

	const PLUGIN_NAME = 'KinesisPlugin';
	this.init = function(appKey /* [options], successCallback, failureCallback */) {

		var successCallback,
			failureCallback,
			options;

		if(arguments.length === 4) {
			options = arguments[1];
			successCallback = arguments[2];
			failureCallback = arguments[3];
		} else if(arguments.length === 3) {
			successCallback = arguments[1];
			failureCallback = arguments[2];
		} else if(arguments.length === 2) {
			options = arguments[1];
		}

		return cordova.exec(successCallback, failureCallback, PLUGIN_NAME, 'initialize', [appKey, options]);
	};
}

if(typeof module !== undefined && module.exports) {

	module.exports = KinesisPlugin;
}

