function KinesisPlugin() {

	const PLUGIN_NAME = 'KinesisPlugin';
	this.init = function(idPoolId, region, successCallback, failureCallback) {

		return cordova.exec(successCallback, failureCallback, PLUGIN_NAME, 'initialize', [idPoolId, region]);
	};

	this.sendMessage = function(message, streamName, successCallback, failureCallback) {

		return cordova.exec(successCallback, failureCallback, PLUGIN_NAME, 'sendMessage', [message, streamName]);
	};

	this.purge = function(successCallback, failureCallback) {

		return cordova.exec(successCallback, failureCallback, PLUGIN_NAME, 'purge', []);
	}
}

if(typeof module !== undefined && module.exports) {

	module.exports = KinesisPlugin;
}
