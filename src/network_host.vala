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
			
			string req = yield dis.read_upto_async("\0", 1, Priority.DEFAULT, null, null);
			dis.read_byte(); //Consume end of stream "\0"
			
			stdout.printf("incoming message\n");
			stdout.printf(req + "\n");
			stdout.printf("end of message\n");
		} catch (Error e) {
			stderr.printf("%s\n", e.message);
		}
	}
	private void create_server() {
		
	}
	
	/*
	 * Not sure what this function should return.
	 * But for now it will return player if succesfully added him to the connected connected_players
	 * otherwise it will return null.
	 */
	public override Player? add_player(Player player) {
		this.connected_players.append(player);
		return player;
	}
}
