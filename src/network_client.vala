public class Network_client : Network {
	private MainLoop waitloop;
	protected SocketClient client;
	protected SocketConnection connection;
	
	public Network_client(string address, Player player, MainLoop loop) {
		base.main_player = player;
		waitloop = loop;
		this.create_connection.begin(address);
		waitloop.run();
	}
	private async void create_connection(string address) throws Error {
		try {
			var resolver = Resolver.get_default();
			var addresses = yield resolver.lookup_by_name_async(address);
			var connection_address = addresses.nth_data(0);
			var socket_address = new InetSocketAddress(connection_address, 38725);
			
			this.client = new SocketClient();
			this.connection = yield this.client.connect_async(socket_address);
			this.connected = true;
			
		} catch (Error e) {
			stderr.printf("%s \n", e.message);
		}
		waitloop.quit();
	}
	
	public override Player? add_player(Player player) {
		try {
			player.address = "get players address";
			string message = "add_player: " + Json.gobject_to_data(player, null);
			
			stdout.printf(message);
			this.send_request.begin(message);
			this.waitloop.run();
			return player;
		} catch (Error e) {
			stderr.printf("%s \n", e.message);
			return null;
		}
		
	}
	
	private async void send_request(string message) {
		
		yield this.connection.output_stream.write_async(message.data, Priority.DEFAULT);
		stdout.printf("Request sent\n");
		this.waitloop.quit();
	}
}