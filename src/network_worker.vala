public class Network_worker : Object {

	public SocketConnection conn;
	public DataInputStream input;
	public DataOutputStream output;
	public signal void message_recieved(string message);
	public signal void message_sent(string message);
	public bool canceled {get; set; default = false;}
	Thread<int> thread;
	
	public Network_worker(SocketConnection _conn) {
		this.conn = _conn;
		this.input = new DataInputStream(this.conn.input_stream);
		this.output = new DataOutputStream(this.conn.output_stream);
	}
	
	public int run() {
		while (this.canceled == false) {
			try {
				string request =  this.input.read_upto("\0", 1 ,null, null);
				stdout.printf(request + "\n");
				this.message_recieved(request);
				this.input.read_byte();
			} catch (Error e) {
			stderr.printf("%s\n", e.message);
			this.canceled = true;
			} 
		}
		return 0;
	}
	
	public async void create(int id) {
			this.canceled = false;
			this.thread = new Thread<int>("NetworkWorker" + id.to_string(), run);
			yield;
			thread.join();
	}
	
	public async void send_message(string message) {
		uint8[] datastream = message.data;
		datastream += '\0';
		try {
			yield this.output.write_async(datastream, Priority.DEFAULT);
			stdout.printf("Request sent\n");
			this.message_sent(message);
		} catch (IOError e) {
			stderr.printf("%s \n", e.message);
		}
	}

}
