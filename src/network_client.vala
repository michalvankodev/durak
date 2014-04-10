public class Network_client : Network {

	protected SocketClient client;
	protected SocketConnection connection;
	
	public Network_client(string address, Player player) {
		this.main_player = player as Network_player;
		this.create_connection.begin(address);
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
			this.on_message_sent(true);
			
		} catch (Error e) {
			stderr.printf("%s \n", e.message);
			this.on_message_sent(false);
		}
	}
	
	public override bool add_player(Player player) {
		try {
			Network_player new_player = player as Network_player;

			string message = "add_player " + Json.gobject_to_data(new_player, null);
			stdout.printf(message);
			
			this.send_request.begin(message);

			return true;
		} catch (Error e) {
			stderr.printf("%s \n", e.message);
			return false; // player is not in game
		}
		
	}
	
	private async void send_request(string message) {
		uint8[] datastream = message.data;
		datastream += '\0';
		try {
			yield this.connection.output_stream.write_async(datastream, Priority.DEFAULT);
			stdout.printf("Request sent\n");
		} catch (IOError e) {
			stderr.printf("%s \n", e.message);
		}
	}
	
	public override void process_connected_player(string player_info, SocketConnection conn) {}

	
}
