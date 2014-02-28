using Gee;
public class Cl_interface : Object, user_interface {
	private const int MAIN = 0;
	
	private HashMap menus = new HashMap<string, Menu>();
	delegate void Action();
	
	private void generate_menus() {
		Menu main = new Menu();
		main.text = "Hello there my friend.\n"+
			"Welcome to Durak card game \n\n"+
			"Main menu: (type number and press ENTER to continue)\n"+
			"1 - Start new game \n"+
			"2 - Settings \n"+
			"3 - Quit \n";
		Action new_game_menu = this.display_menu("new_game");
		main.add_option(new Menu.Option("Start new game", new_game_menu));
		
	}
	
	
	public void display_main_menu() {
		string to_print = "Hello there my friend.\n"+
			"Welcome to Durak card game \n\n"+
			"Main menu: (type number and press ENTER to continue)\n"+
			"1 - Start new game \n"+
			"2 - Settings \n"+
			"3 - Quit \n";
		stdout.printf(to_print);
		
		this.resolve_menu(MAIN, stdin.read_line());
	}
	
	private void resolve_menu(int menu, string input) {
		if (menu == MAIN) {
			
		}
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
		
		public class Option : Object {
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
	
	// MENU WILL FUNCTION AS HASHMAP
	/* FIGURE OUT pointing to function from another method
	 Look up delegates and signals. Find actual solution...*/
}