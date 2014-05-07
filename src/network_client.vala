public class Network_client : Network {

	protected SocketClient client;
	protected Network_connection connection;
	
	public Network_client(string address, Player player) {
		this.main_player = player;
		this.playing_players = new List<Player>();
		this.create_connection.begin(address);
	}
	private async void create_connection(string address) throws Error {
		try {
			var resolver = Resolver.get_default();
			var addresses = yield resolver.lookup_by_name_async(address);
			var connection_address = addresses.nth_data(0);
			var socket_address = new InetSocketAddress(connection_address, 38725);
			
			this.client = new SocketClient();
			SocketConnection conn = yield this.client.connect_async(socket_address);
			this.connection = new Network_connection(conn);
			
			// New connections will always send their credentials
			this.send_credentials(this.main_player);
			
			this.connected = true;
			
			this.connection.worker.message_sent.connect((t, message) => {
				this.on_message_sent(message);
			});
			this.connection.worker.message_recieved.connect((t, message) => {
				this.on_message_recieved(message);
			});
			
			
		} catch (Error e) {
			stderr.printf("%s \n", e.message);
		}
	}
	
	private void send_credentials(Player player) {
		string message = "new_connection " + Json.gobject_to_data(player, null);
		this.connection.send(message);

	}
	
	public override bool add_player(Player player) {
			string message = "add_player " + Json.gobject_to_data(player, null);
			stdout.printf(message);
			
			this.connection.send(message);

			return true;
	}
	
	
	
	public override void add_new_connection(string player_info, SocketConnection conn) {}

	
}
