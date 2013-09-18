#!/usr/bin/perl 

# Compress PNG files.
#  
# @usage: [script name].pl [source dir] [backup dir] 
# @author Ananda Raj Pandey
# Script is inspired by the code written by Shay Anderson


use strict; 
# use warnings
 
use File::Copy qw(copy);
# Copy module
 
$SIG{CHLD}='IGNORE';
# dont run as zombie

my($dir_read, $dir_write)=@ARGV;
# input arguments


my $allowed_file_type = '^(.+)png$'; 
# allow convert file type  

 

# check for valid dirs  
if(($dir_read eq '')||($dir_write eq '')) {  
      print "\nUsage: " . __FILE__ . " [source dir] [backup dir]  
      Examples:  
      \t perl " . __FILE__ . " \"/var/www/example/images\" \"/var/www/example/images/backup\"  
      \t perl " . __FILE__ . " images output debug\n\n";  
      exit;  
}  

# check if valid read dir  
if(! -d "$dir_read") {  
      print "Error: failed to find source directory: $dir_read\n";  
      exit;  
}  

# check if valid write dir  
if(! -d "$dir_write") {
        unless(mkdir $dir_write) {
		die "Unable to create $dir_write\n";
	}
      
      exit;  
}  

# dir read subdirs  
my @dir_list;  
my $dir_list_index = -1;  

# dir read files  
my @file_list;  
my $file_list_index = -1;  
my @file_dir_list;  

# set read subdirs and files  
setReadParts($dir_read);  

# check for file count  
if($file_list_index == -1) {  
      print "Error: no source files found\n";  
      exit;  
}  

# display counters  
my $file_counter = $file_list_index + 2;  
print "$file_counter files found\n";  

# create target dirs  
makeWriteDirs(@dir_list);  

# convert files  
 convertFiles(); 


#------------------------------------------------  
# Set read subdirs and files  
#------------------------------------------------  
sub setReadParts {  
      my $dir_read = $_[0];  
      my @parts;  
      my $part;  
        
      opendir(READDIR, $dir_read) or die "Error: failed to open source directory: $dir_read\n";  
        
      
      @parts = grep { $_ ne '.' and $_ ne '..' } readdir READDIR;  
        
      closedir READDIR;  
        
      foreach $part(@parts) {  
            # check if dir  
            if(-d "$dir_read/$part") {  
                  # add to dir list  
                  $dir_list[++$dir_list_index] = "$dir_read/$part";  
              
                  # walk dir  
                  setReadParts("$dir_read/$part");  
            }  
              
            # check if allow file type 
            if($part =~ /^$allowed_file_type/i) {  
                  # add file  
                  $file_list[++$file_list_index] = "$part";  
                  $file_dir_list[$file_list_index] = "$dir_read";  
            }  
      }  
}  



#------------------------------------------------  
# Make write directories  
#------------------------------------------------  
sub makeWriteDirs {  
      my $dir;  
      my $dirs_created = 0;  
      my $dirs_exist = 0;  
      foreach $dir(@dir_list) {  
            (my $dir_source, my $dir_make) = split(/$dir_read\//, $dir);  
            # check if dir already exists  
            if(! -d "$dir_write/$dir_make") {  
                  # make dir  
                  mkdir("$dir_write/$dir_make") or die "Error: failed to create directory: $dir_write/$dir_make\n";  
                  $dirs_created++;  
            } else {  
                  print "Target directory already exists: $dir_write/$dir_make\n";  
                  $dirs_exist++;  
            }  
              
      }  
        
      if(($dirs_created > 0)||($dirs_exist > 0)) {  
            print "$dirs_created target directories created\n";  
      } else {  
            print "Warning: failed to create target directories\n"; 
            exit;
      }  
}  



#------------------------------------------------  
# Convert files to PNG  
#------------------------------------------------  
sub convertFiles {  
      my $converted_files = 0;  

      for(my $i = 0; $i <= $file_list_index; $i++) {  
            my $file_name = @file_list[$i];  
            my $file_dir = @file_dir_list[$i];  
              
            my $read_name = "$file_dir/$file_name";  
              
            (my $dir_source, my $dir_sub_write) = split(/$dir_read\//, $file_dir);  
              
            
            my $write_name = "$dir_write/$dir_sub_write$file_name";  
            
            # copy to backup 
            copy("$read_name", "$write_name") or die "Copy failed: $!";
            
            my $result = `optipng -o7 $read_name && advpng -z -4 $read_name && advdef -z -4 $read_name   && pngcrush -rem gAMA -rem alla -rem cHRM -rem iCCP -rem sRGB -rem time $read_name`;
            print "$result\n\n";
              
      }  
        
      print "\n$converted_files Total files converted\n\n";  
}