public class Network_host : Network {
	protected SocketService server;
	
	public Network_host(Player player) {
		try {
			this.server = new SocketService();
			this.server.add_inet_port(38725, null);
			this.server.incoming.connect(this.on_incoming_connection);
			this.server.start();
			
			this.connected_players = new List<Player>();
			this.connected = true;

			
		} catch (Error e) {
			stderr.printf("%s\n", e.message);
		}
	}
	
	private bool on_incoming_connection (SocketConnection conn) {
		this.process_request.begin(conn);
		return true;
	}
	
	private async void process_request(SocketConnection conn) {
		try {
			var dis = new DataInputStream(conn.input_stream);
			var dos = new DataOutputStream(conn.output_stream);
			
			string request = yield dis.read_upto_async("\0", 1, Priority.DEFAULT, null, null);
			dis.read_byte(); //Consume end of stream "\0"
			
			this.process_message(request);
		} catch (Error e) {
			stderr.printf("%s\n", e.message);
		}
	}

	private void process_message(string message) {
		int split_index = message.index_of(" "); 
		string action = message.substring(0, split_index);
		string content = message.substring(split_index + 1);
		
		switch(action) {
		case "add_player" :
			var parser = new Json.Parser();
			parser.load_from_data(content);
			
			var player_info = parser.get_root().get_object();
			
			Player player = new Player(player_info.get_string_member("name"));
			player.address = player_info.get_string_member("address");
			
			stdout.printf("player name: " + player.name);
			stdout.printf("players address: " + player.address);
			stdout.printf(content);
			
			this.add_player(player);
			break;
		default:
			stdout.printf("Unknown action " + action +" requested\n");
			break;
		}
	}
	
	/*
	 * Not sure what this function should return.
	 * But for now it will return player if succesfully added him to the connected connected_players
	 * otherwise it will return null.
	 */
	public override Player? add_player(Player player) {
		this.connected_players.append(player);
		this.new_player_connected(player);

		return player;
	}
}
