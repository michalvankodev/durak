public class Network_worker : Object {

	public SocketConnection conn;
	public DataInputStream input;
	public DataOutputStream output;
	public signal void message_received(string message);
	public bool canceled {get; set; default = false;}
	Thread<int> thread;
	
	public Network_worker(SocketConnection _conn) {
		this.conn = _conn;
		this.input = new DataInputStream(this.conn.input_stream);
		this.output = new DataOutputStream(this.conn.output_stream);
	}
	
	public int run() {
		while (this.canceled == false) {
			string request =  this.input.read_upto(" ", 1 ,null, null);
			this.message_received(request);
			this.input.read_byte(); 
		}
		return 0;
	}
	
	public async void create() {
		this.canceled = false;
		this.thread = new Thread<int>("NetworkWorker", run);
	}

}
