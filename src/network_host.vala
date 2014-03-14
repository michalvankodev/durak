public class Network_host : Network {
	protected SocketService server;
	private MainLoop waitloop;
	
	public Network_host(Player player, MainLoop loop) {
		try {
			this.server = new SocketService();
			this.server.add_inet_port(38725, null);
			this.server.incoming.connect(this.process_connection);
			this.server.start();
			
			this.connected = true;
			
			this.waitloop = loop;
			stdout.printf("Server inicialized");
			
		} catch (Error e) {
			stderr.printf("%s\n", e.message);
		}
	}
	
	private bool process_connection (SocketConnection conn) {
		this.process_request.begin(conn);
		return true;
	}
	
	private async void process_request(SocketConnection conn) {
		try {
			var dis = new DataInputStream(conn.input_stream);
			var dos = new DataOutputStream(conn.output_stream);
			
			string req = yield dis.read_line_async (Priority.HIGH_IDLE);
			stdout.printf(req);
		} catch (Error e) {
			stderr.printf("%s\n", e.message);
		}
	}
	private void create_server() {
		
	}
}