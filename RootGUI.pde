
class RootGUI extends JFrame implements ActionListener, 
ItemListener {

  JLabel clockLabel = new JLabel("Clock: 0", JLabel.LEFT);
  JLabel phaseLabel = new JLabel("Phase: 0", JLabel.LEFT);

  JLabel help = new JLabel(HELP_STRING, JLabel.LEFT);


  JMenuItem saveConfigItem = new JMenuItem("Save Config");
  JMenuItem loadConfig1 = new JMenuItem("Load Config 1");
  JMenuItem loadConfig2 = new JMenuItem("Load Config 2");
  JMenu file = new JMenu("File");

  PApplet app;

  RootGUI(PApplet app) {
    super("Status");
    println("instantiating RootGUI");
    this.app = app;


    JMenuBar menuBar = new JMenuBar();


    file.add(saveConfigItem);

    file.add(loadConfig1);
    loadConfig1.addActionListener(this );
    file.add(loadConfig2);
    loadConfig2.addActionListener(this );

    menuBar.add(file);
    setJMenuBar(menuBar);
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

    Container content = getContentPane();
    content.setLayout(new BoxLayout(content, BoxLayout.PAGE_AXIS));

    content.add(clockLabel);
    content.add(phaseLabel);
    content.add(help);
  }


  void actionPerformed(ActionEvent e) {
    PBox.println("handle action "+e.getActionCommand());
  }

  void itemStateChanged(ItemEvent e) {
    PBox.println("item state changed "+e);
  }
  
  static final String HELP_STRING = "<html><br><hr>Help<hr>double-click: reset camera position<br>'B': Beanshell console window<br></html>";

}
