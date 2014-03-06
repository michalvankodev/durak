class durak : Object {
	public static int main (string[] args) {
		
		// Load settings
		Game_settings settings = Game_settings.load();
		settings.notify.connect((sender, property) => {
			stdout.printf("property changed");
			settings.save();
		});
		
		user_interface interface = new Cl_interface(settings);

		return 0;
	}
}