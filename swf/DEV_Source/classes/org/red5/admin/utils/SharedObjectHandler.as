package org.red5.admin.utils {
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.SharedObject;

	public class SharedObjectHandler extends EventDispatcher{
		
		private var sharedObject:SharedObject;
		private static var _instance:SharedObjectHandler;
		
		public function SharedObjectHandler( singleton:SingletonEnforcer ) {
			super();
			sharedObject = SharedObject.getLocal("ServerData","/");
			//sharedObject.data.hosts = null
			//sharedObject.data.lasthost = null
			resetHosts()
		}
		
		public static function getInstance():SharedObjectHandler {
			if ( _instance == null ) {
				_instance = new SharedObjectHandler( new SingletonEnforcer() );
			}
			return _instance;
		}
		
		private function resetHosts():void{
			if ( sharedObject.data.hosts == null ) {
				sharedObject.data.lasthost = 0
				sharedObject.data.hosts = new Array();
			}
		}
		
		public function getHosts () : Array {
			resetHosts()
			var hosts:Array = new Array();
			for ( var i:Number = 0 ; i < sharedObject.data.hosts.length ; i++ ) {
				hosts.push ( sharedObject.data.hosts[i].host );
			}
			return hosts;
		}
				
		public function getUsername ( host:String ) : String {
			var user:String = "";
			var id:Number = checkHost ( host );
			if ( id != -1 ) {
				user = sharedObject.data.hosts[id].user
			}
			return user;
		}
		
		public function getPasswd ( host:String ) : String {
			var user:String = "";
			var id:Number = checkHost ( host );
			if ( id != -1 ) {
				user = sharedObject.data.hosts[id].passwd;
			}
			return user;
		}
		
		public function checkHost ( host:String ) : Number {
			resetHosts()
			for ( var i:Number = 0 ; i < sharedObject.data.hosts.length ; i++ ) {
				if ( sharedObject.data.hosts[i].host == host  ) {
					return i;
				}
			}
			return -1;
		}
		
		public function removeHost(host:String):void{
			var index:Number = checkHost ( host );
			if ( index != -1 ) {
				sharedObject.data.hosts.splice(index,1);
			}
		}
		
		public function saveHost(hostID:Number , host:String , user:String , passwd:String ) : void {
			sharedObject.data.hosts[hostID].host = host;
			sharedObject.data.hosts[hostID].user = user;
			sharedObject.data.hosts[hostID].passwd = passwd;
		}
		
		public function addHost ( host:String , user:String , passwd:String ) : void {
			resetHosts()
			var index:Number = checkHost ( host );
			if ( index == -1 ) {
				sharedObject.data.hosts.push ( { host:host , user:user ,passwd:passwd} )
				index = sharedObject.data.hosts.length - 1;
			}else{
				sharedObject.data.hosts[index].user = user;
				sharedObject.data.hosts[index].passwd = passwd;
			}
			sharedObject.data.lasthost = index;
		}
		
		public function get lasthost () : Number {
			return sharedObject.data.lasthost;
		}
	}
}

class SingletonEnforcer {}