using Gee;
public class Cl_interface : Object, user_interface {
	private const int MAIN = 0;
	
	private HashMap<string, Menu> menus = new HashMap<string, Menu>();
	delegate void Action();
	
	public Cl_interface() {
		generate_menus();
		display_main_menu();
	}
	
	private void generate_menus() {
		// Main menu 
		Menu main = new Menu();
		main.text = "Hello there my friend.\n"+
			"Welcome to Durak card game \n\n"+
			"Main menu: (type number and press ENTER to continue)\n";
		Action new_game_menu = () => { this.display_menu("new_game_menu"); };
		main.add_option(new Option("Start new game", new_game_menu));
		
		this.menus.set("main_menu", main);
		
		// New game menu
		Menu new_game = new Menu();
		new_game.text = "Good choice!\n\nChoose what type of game do you want to play:\n";
		
		Action local_game = () => { this.display_menu("local_game_menu"); };
		new_game.add_option(new Option("Play against computer", local_game));
		
		Action host_game = () => { };
		new_game.add_option(new Option("Host online game", host_game));
		
		this.menus.set("new_game_menu", new_game);
		
	}
	
	public void display_menu(string menu_id) {
		if (this.menus[menu_id] != null)
			this.menus[menu_id].display();
	}
	
	public void display_main_menu() {
		this.display_menu("main_menu");
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
			try {
				stdout.printf(this.text + "\n");
				
				int i = 0; 
				foreach (Option option in this.options) {
					stdout.printf((++i).to_string() + " - " + option.text + "\n");
				}
				
				this.resolve_menu(stdin.read_line());
				
			} catch (Error e) {
				stdout.printf(e.message);
			}
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
	// MENU WILL FUNCTION AS HASHMAP
	/* FIGURE OUT pointing to function from another method
	 Look up delegates and signals. Find actual solution...*/
}