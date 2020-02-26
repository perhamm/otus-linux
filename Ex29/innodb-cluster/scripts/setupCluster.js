var dbPass = "mysql"
var clusterName = "devCluster"

try {
  print('Setting up InnoDB cluster...\n');
  shell.connect('root@mysql-server-1:3306', dbPass);
  var cluster = dba.createCluster(clusterName);
  print('Adding instances to the cluster.');
  cluster.addInstance({user: "root", host: "mysql-server-2", password: dbPass}, {recoveryMethod: 'clone'});
  print('.\nmysql-server-2 successfully added to the cluster.');
  cluster.addInstance({user: "root", host: "mysql-server-3", password: dbPass}, {recoveryMethod: 'clone'});
  print('.\nmysql-server-3 added to the cluster.');
  cluster.switchToMultiPrimaryMode();
  print('\nInnoDB cluster deployed successfully.\n');
  cluster.status();
} catch(e) {
  print('\nThe InnoDB cluster could not be created.\n\nError: ' + e.message + '\n');
}
