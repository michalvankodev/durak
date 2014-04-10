public class Network_host : Network {
	private int last_player_id = 0;
	protected SocketService server;
	protected List<SocketConnection> connections = new List<SocketConnection>();
	private FileIOStream syncfile_stream;
	private File syncfile;
	private DataOutputStream syncfile_output_stream;
	
	public Network_host(Player player) {
		try {
			this.server = new SocketService();
			this.server.add_inet_port(38725, null);
			this.server.incoming.connect(this.on_incoming_connection);
			this.server.start();
			
			this.syncfile = File.new_tmp("durakgame.txt", out this.syncfile_stream);
			this.syncfile_output_stream = new DataOutputStream(this.syncfile_stream.output_stream);
			this.syncfile_output_stream.put_string("starting_new_game\n");
			
			this.connected_players = new List<Network_player>();
			this.connected = true;

			
		} catch (Error e) {
			stderr.printf("%s\n", e.message);
		}
	}
	
	private int next_player_id() {
		return ++this.last_player_id;
	}
	
	private bool on_incoming_connection (SocketConnection conn) {
		this.process_request.begin(conn);
		return true;
	}
	
	private async void process_request(SocketConnection conn) {		
		if (this.connections.index(conn) < 0) {
			this.connections.append(conn);
			this.sync(conn);
		}
		try {
			var dis = new DataInputStream(conn.input_stream);
			
			string request = yield dis.read_upto_async("\0", 1, Priority.DEFAULT, null, null);
			dis.read_byte(); //Consume end of stream "\0"
			
			this.process_message(request, conn);
		} catch (Error e) {
			stderr.printf("%s\n", e.message);
		}
	}
	
	public override void process_connected_player(string player_info, SocketConnection conn) {
		var parser = new Json.Parser();
		try {
			parser.load_from_data(player_info);
		
			var parsed_info = parser.get_root().get_object();
		
			Network_player player = new Player(parsed_info.get_string_member("name")) as Network_player;
			player.address = parsed_info.get_string_member("address");
			player.id = this.next_player_id();
			player.connection = conn;
			
			this.add_network_player(player);
			
			this.send_to_player.begin(player, "yourID " + player.id.to_string());
			
		} catch (Error e) {
			stderr.printf("%s \n", e.message);
		}
	}

	public override bool add_player(Player player) {
		Network_player new_player = player as Network_player;
		new_player.id = next_player_id();
		
		return true;
	}
	
	private Network_player add_network_player(Network_player player) {
		this.connected_players.append(player);
		this.new_player_connected((Player) player);
		return player;
	}
	
	private async void send_all(string message) {
		uint8[] datastream = message.data;
		datastream += '\0';
		
		yield;
		this.connections.foreach((conn) => {
			try {
				var dos = new DataOutputStream(conn.output_stream);
				dos.write_async(datastream, Priority.DEFAULT);
			} catch (IOError e) {
				stderr.printf("%s \n", e.message);
			}
		});
		
		try {
			this.syncfile_output_stream.put_string(message+"\0");
		} catch (IOError e) {
			stderr.printf("%s \n", e.message);
		}
	}
	
	private async void send_to_player(Network_player player, string message) {
		uint8[] datastream = message.data;
		datastream += '\0';
		
		try {
			var dos = new DataOutputStream(player.connection.output_stream);
			yield dos.write_async(datastream, Priority.DEFAULT);
		} catch (IOError e) {
			stderr.printf("%s \n", e.message);
		}
	}
	
	/* Send everything what happend to the connection */
	private void sync(SocketConnection conn) {
	}
	
	
}
