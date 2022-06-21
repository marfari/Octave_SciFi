%Installation of packages. Run once after installing Octave.

disp('Installing packages needed for scanner software:');

disp('   control...');
pkg install -forge control
disp('   signal...');
pkg install -forge signal
disp('   struct...');
pkg install -forge struct
disp('   optim...');
pkg install -forge optim
disp('   splines...');
pkg install -forge splines
disp('Ready!');