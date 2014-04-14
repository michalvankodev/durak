public class Network_host : Network {
	protected SocketService server;
	protected List<Network_connection> connections = new List<Network_connection>();
	protected int last_connection_id = 0;
	
	private FileIOStream syncfile_stream;
	private File syncfile;
	private DataOutputStream syncfile_output_stream;
	
	public Network_host(Player player) {
		this.main_player = player;
		this.create_server();
		
		this.playing_players = new List<Player>();
		this.connected = true;

	}
	
	private void create_server() {
		try {
			this.server = new SocketService();
			this.server.add_inet_port(38725, null);
			this.server.incoming.connect(this.on_incoming_connection);
			this.server.start();
		
			this.syncfile = File.new_tmp("durakgame-XXXXXX.txt", out this.syncfile_stream);
			this.syncfile_output_stream = new DataOutputStream(this.syncfile_stream.output_stream);
			this.syncfile_output_stream.put_string("starting_new_game\n");
			
		} catch (Error e) {
			stderr.printf("%s\n", e.message);
		}	
	}
	
	private int next_connection_id() {
		return ++this.last_connection_id;
	}
	
	private bool on_incoming_connection (SocketConnection conn) {
		this.process_request.begin(conn);
		return true;
	}
	
	private async void process_request(SocketConnection conn) {		
		try {
			var dis = new DataInputStream(conn.input_stream);
			
			string request = yield dis.read_upto_async("\0", 1, Priority.DEFAULT, null, null);
			dis.read_byte(); //Consume end of stream "\0"
			
			this.process_message(request, conn);
		} catch (Error e) {
			stderr.printf("%s\n", e.message);
		}
	}
	
	
	
	
	public override void add_new_connection(string player_info, SocketConnection conn) {
		var parser = new Json.Parser();
		try {
			parser.load_from_data(player_info);
		
			var parsed_info = parser.get_root().get_object();
		
			Player player = new Player(parsed_info.get_string_member("name"));
			int player_id = this.next_connection_id();
			
			Network_connection new_conn = new Network_connection(player, conn, player_id); 
			
			this.connections.append(new_conn);
			
			this.send_back.begin(conn, "yourID " + player_id.to_string());
			
		} catch (Error e) {
			stderr.printf("%s \n", e.message);
		}
	}

	public override bool add_player(Player player) {

		return true;
	}
	
	
	private async void send_all(string message) {
		uint8[] datastream = message.data;
		datastream += '\0';
		
		yield;
		this.connections.foreach((net_conn) => {
			try {
				var dos = new DataOutputStream(net_conn.connection.output_stream);
				dos.write_async.begin(datastream, Priority.DEFAULT);
			} catch (IOError e) {
				stderr.printf("%s \n", e.message);
			}
		});
		
		try {
			this.syncfile_output_stream.put_string(message+"!\n");
		} catch (IOError e) {
			stderr.printf("%s \n", e.message);
		}
	}
	
	/* QUESTIONABLE TODO */
	private async void send_to_player(Player player, string message) {
		
	}
	
	private async void send_back(SocketConnection conn, string message) {
		uint8[] datastream = message.data;
		datastream += '\0';
		
		try {
			var dos = new DataOutputStream(conn.output_stream);
			yield dos.write_async(datastream, Priority.DEFAULT);
		} catch (IOError e) {
			stderr.printf("%s \n", e.message);
		}
	
	}	
		
	/* Send everything what happend to the connection */
	private void sync(SocketConnection conn) {
	}
	
	
}
