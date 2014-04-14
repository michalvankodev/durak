using Gee;
public class Cl_interface : Object, user_interface {
	private Game_settings settings;
	private Network network;
	private MainLoop waitloop;
	
	public Player main_player; 
	
	private HashMap<string, Menu> menus = new HashMap<string, Menu>();
	delegate void Action();
	
	public Cl_interface(Game_settings _settings) {
		this.settings = _settings;
		this.main_player = new Player(settings.player_name);
		this.generate_menus();
		waitloop = new MainLoop();
		this.display_menu("main_menu");
	}
	
	private void generate_menus() {
		// Back to main menu action
		Action back_to_main = () => { this.display_menu("main_menu"); };
		
		// Main menu 
		Menu main = new Menu();
		main.text = "Hello there my friend.\n"+
			"Welcome to Durak card game \n\n"+
			"Main menu: (type number and press ENTER to continue)\n";
		Action new_game_menu = () => { this.display_menu("new_game_menu"); };
		main.add_option(new Option("Start new game", new_game_menu));
		
		Action to_settings = () => { this.display_menu("settings_menu"); };
		main.add_option(new Option("Settings", to_settings));
		
		Action quit = () => { this.quit(); };
		main.add_option(new Option("Quit", quit));
		
		this.menus.set("main_menu", main);
		
		// New game menu
		Menu new_game = new Menu();
		new_game.text = "Good choice!\n\nChoose what type of game do you want to play:\n";
		
		Action local_game = () => { this.display_menu("local_game_menu"); };
		new_game.add_option(new Option("Play against computer", local_game));
		
		Action connect_to_game = () => { this.connect_to_game(); };
		new_game.add_option(new Option("Connect to new online game", connect_to_game));
		
		Action host_game = () => { this.host_online_game(); };
		new_game.add_option(new Option("Host online game", host_game));
		
		new_game.add_option(new Option("Back", back_to_main));
		
		this.menus.set("new_game_menu", new_game);
		
		// Setting menu
		Menu settings_menu = new Menu();
		settings_menu.text = "Settings menu:\n";
		
		Action change_name = () => {
			this.change_name();
			this.display_menu("settings_menu");
			
		};
		settings_menu.add_option(new Option("Change name", change_name));
		settings_menu.add_option(new Option("Back", back_to_main));
		
		this.menus.set("settings_menu", settings_menu);
	}
	
	public void connect_to_game() {
		
		stdout.printf("Type IP of the game host:\nType 'q' to return to menu:\n");
		string host_ip = stdin.read_line();
		if (host_ip == "q") {
			this.display_menu("new_game_menu");
		} else {
			this.network = new Network_client(host_ip, this.main_player);

			/* Connect to host and wait for players to load 
			 * and when host runs the game notify and start game
			 * Create MAINLOOP for waiting on the notifications
			 */		
			 	
			ulong handler = this.network.on_message_sent.connect((t, success) => {
				this.waitloop.quit();
			});
			
			this.waitloop.run();
			this.network.disconnect(handler);
			
			if (this.network.connected) {
				stdout.printf("Successfully connected to " + host_ip + "\n");
				
				this.network.add_player(this.main_player);
				
				stdout.printf("Waiting for game to start\n");
				this.wait_for_players();
			} else {
				stdout.printf("Connection failed.\n");
				this.connect_to_game();
			}
			
		}
	}
	
	public void host_online_game() {
		this.network = new Network_host(this.main_player);
		
		if (this.network.connected) {
			this.network.add_player(this.main_player);
			
			this.network.new_player_connected.connect((t, player) => {
				stdout.printf("New player "+ player.name +" connected.\n");
				this.print_connected_players();		
			});
			
			stdout.printf("Hosting a game. Waiting for players. \n"+
				"Type 'start' to start the game\n");
			
			this.wait_for_input.begin(() => {
				this.waitloop.quit();
			});
			this.waitloop.run();
			
		} else {
			stdout.printf("Something went wrong\n");
		}
	}
	
	private async string wait_for_input() {
		SourceFunc callback = wait_for_input.callback;
		string output = "";
		ThreadFunc<string?> run = () => {
			output = stdin.read_line();
			Idle.add((owned) callback);
			return null;
		};
		try {
			Thread<string> thread = new Thread<string>.try("Input thread", run);
			output = thread.join();
		} catch (Error e) {
			stderr.printf("%s \n", e.message);
		}
		
		return output;
	}
	
	private void wait_for_players() {
		//Figure out how to asyncly wait for game start
		this.print_connected_players();
		
		this.network.new_player_connected.connect((t, player) => {
			stdout.printf("New player "+ player.name +" connected.\n");
			this.print_connected_players();		
		});
		
		this.network.game_started.connect((t) => {
			this.waitloop.quit();
		});
		
		this.waitloop.run();

		stdout.printf("You have succesfully waited to this moment");
	}
	
	private void print_connected_players() {
		stdout.printf("Players connected:\n");
		
		int n = 0;
		network.playing_players.foreach ((player) => {
			stdout.printf((++n).to_string() + ". " + player.name + "\n");
		});
	}
	
	public void display_menu(string menu_id) {
		if (this.menus[menu_id] != null)
			this.menus[menu_id].display();
		else
			stdout.printf("ERROR: Menu " + menu_id + " doesn't exist.");
	}
	
	public void quit() {
		stdout.printf("Goodbye !\n");
	}
	
	public void change_name() {
		stdout.printf("What's your name? \n");
		this.settings.player_name = stdin.read_line();
		stdout.printf("Nice to meet you " + this.settings.player_name +" \n");
	}
	
	private class Menu : Object {
		public string text;
		public Option[] options;
		
		public Menu() {}
		public Menu.from(string _text, Option[] _options) {
			this.text = _text;
			this.options = _options;
		}
		
		public void add_option(Option option) {
			this.options += option;
		}
		public void display() {
			
			stdout.printf(this.text + "\n");
			
			int i = 0; 
			foreach (Option option in this.options) {
				stdout.printf((++i).to_string() + " - " + option.text + "\n");
			}
			
			this.resolve_menu(stdin.read_line());
				
		}
		
		public void resolve_menu(string input) {
			int choice = int.parse(input);
			
			// +1/-1 because user choice is one higher then it is in array
			if (choice > 0 && choice < this.options.length+1) {
				this.options[choice-1].action();
			}
			else {
				this.display();
			}
		}
	}
	
	private class Option : Object {
		public string text;
		public Action action;
		
		public Option(string _text, Action _action) {
			this.text = _text;
			this.action = _action;
		}
		public string to_string() {
			return this.text;
		}
	}
	
}
