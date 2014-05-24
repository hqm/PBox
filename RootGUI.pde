
class RootGUI extends JFrame implements ActionListener, 
ItemListener {

  JLabel clockLabel = new JLabel("Clock: 0", JLabel.LEFT);
  JLabel phaseLabel = new JLabel("Phase: 0", JLabel.LEFT);
  JLabel directionLabel = new JLabel("Direction: forward", JLabel.LEFT);
  JLabel speedLabel = new JLabel("Speed: fast", JLabel.LEFT);


  JLabel debugLabel = new JLabel("Debug: true", JLabel.LEFT);

  JLabel help = new JLabel(HELP_STRING, JLabel.LEFT);


  JMenuItem saveConfigItem = new JMenuItem("Save Config");
  JMenuItem clearItem = new JMenuItem("Clear");
  JMenuItem loadConfig1 = new JMenuItem("Load Config 1");
  JMenuItem loadConfig2 = new JMenuItem("Load Config 2");
  JMenu file = new JMenu("File");

  PBox app;

  RootGUI(PBox app) {
    super("Status");
    println("instantiating RootGUI");
    this.app = app;


    JMenuBar menuBar = new JMenuBar();


    file.add(saveConfigItem);
    file.add(clearItem);
    file.add(loadConfig1);
    file.add(loadConfig2);
    loadConfig2.addActionListener(this );
    clearItem.addActionListener(this);
    loadConfig1.addActionListener(this );

    menuBar.add(file);
    setJMenuBar(menuBar);
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

    Container content = getContentPane();
    content.setLayout(new BoxLayout(content, BoxLayout.PAGE_AXIS));

    content.add(clockLabel);
    content.add(phaseLabel);
    content.add(directionLabel);
    content.add(speedLabel);
    content.add(debugLabel);

    content.add(help);
  }


  void actionPerformed(ActionEvent e) {
    PBox.println("handle action "+e.getActionCommand());
    String cmd = e.getActionCommand();
    if (cmd.equals("Load Config 1")) {
      app.loadConfig(1);
    } else if (cmd.equals("Load Config 2")) {
      app.loadConfig(2);
    } else if (cmd.equals("Clear")) {
      PBox.println("clear world");
      app.loadConfig(0);
    }
  }

  void itemStateChanged(ItemEvent e) {
    PBox.println("item state changed "+e);
  }

  static final String HELP_STRING = "<html><br><hr>Help<hr>"
    +"double-click: reset camera position<br>"
    +"B: Beanshell console window<br>"
    +"D: toggle debug logging"
    +"z: forward/reverse direction"
    +"s: toggle fast/slow"
    +"</html>";
}
