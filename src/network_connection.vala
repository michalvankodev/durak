public class Network_connection : Object {
	public Player player {get; set;}
	public int id {get; set; default = 0;}
	public Network_worker worker;
	
	public Network_connection(SocketConnection _conn, int _id = 0) {
		this.id = _id;
		this.worker = new Network_worker(_conn);
		this.worker.create.begin();
		stdout.printf("worker creted\n");
	}
}
