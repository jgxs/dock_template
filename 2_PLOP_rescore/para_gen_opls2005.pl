#!/usr/bin/perl
# Automatically submitting job for para_gen OPLS 2005
# Yu Zhou, 2013-08-10
# Modified on 2013-08-14. 
# -- 1. Submitting each directory seperately; 
# -- 2. Collected each log and err file together into the output directory; 
# -- 3. Check the output directory firstly to avoid deleting results by mistake.
# Modified on 2014-02-26
# -- add the filecheck, to generate sge script only. Thus users could submit the job by themselves.

use warnings;
########################################################################################
$schrodinger_path = "/home/yjcheng/schrodinger2016-2";
$para_script = "/home/yjcheng/handbook/2-Good-practices-in-research/Docking/PLOP-rescore-DOCK3.7-results/";
$user = "yjcheng";
########################################################################################

if (@ARGV == 3) {
    $name = $ARGV[0];
    $input = $ARGV[1];
    $queue = $ARGV[2];
    chomp($pwd = `pwd`);
    $output = $pwd;
    $number = 1000;
    $filecheck = "No";
}
elsif (@ARGV == 4) {
    $name = $ARGV[0];
    $input = $ARGV[1];
    $queue = $ARGV[2];
    $output = $ARGV[3];
    $number = 1000;
    $filecheck = "No";
}
elsif (@ARGV == 5) {
    $name = $ARGV[0];
    $input = $ARGV[1];
    $queue = $ARGV[2];
    $output = $ARGV[3];
    $number = $ARGV[4];
    $filecheck = "No";
    #ligs_${num} $line honda . 10
}
elsif (@ARGV == 6) {
    $name = $ARGV[0];
    $input = $ARGV[1];
    $queue = $ARGV[2];
    $output = $ARGV[3];
    $number = $ARGV[4];
    $filecheck = $ARGV[5];
}
else
{
    die "Usage: ./para_gen_opls2005.pl   Jobname   Input_eel.gz   queue   [Output_path]   [Het numbers in each dir] [File: for generating sge script only without submitting]\n";
}

if (! -e "$output")
{
    mkdir "$output", 0755 or die "Creating directory $output failed ! Please check !\n";
}
#mkdir "$output/$name", 0755 or warn "";
#mkdir "$output/$name/mol_tmp", 0755 or warn "";
#mkdir "$output/$name/mol_tmp/decoys.000001", 0755 or warn "";

print ">>>>>>>>>> Spliting Poses for $input ..........\n";
#`$para_script/mol_split.pl $input $number $output/$name/mol_tmp`;


# `/home/yjcheng/handbook/2-Good-practices-in-research/Docking/PLOP-rescore-DOCK3.7-results/split.sh $input $number $output $name`;
# split.sh test_0001.mol2 10 . lig_0001 

print ">>>>>>>>>> Generating Sge Scripts ..........\n";
mkdir "$output/$name/sge_tmp", 0755 or warn "Creating directory $output/$name/sge_tmp failed !\n";
mkdir "$output/$name/decoys", 0755 or warn "Creating directory $output/$name/decoys failed !\n";
chomp (@dir = `ls $output/$name/mol_tmp/`);
foreach $id (@dir)
{
    open (OUT, ">$output/$name/sge_tmp/para_$name-$id.sge.sh") or die "Could not open file:  $output/$name/sge_tmp/para_$name-$id.sge.sh\n";
    print OUT "#!/bin/sh\n";
    print OUT "#\$ -S /bin/sh\n";
    print OUT "#\$ -cwd\n";
    print OUT "#\$ -o $output/$name/sge_tmp/$name-$id.log\n";
    print OUT "#\$ -e $output/$name/sge_tmp/$name-$id.err\n";
    print OUT "#\$ -j y\n";
    print OUT "#\$ -r y\n";
    print OUT "#\$ -t 1-1\n\n";
    print OUT "date\n";
    print OUT "hostname\n\n";
    print OUT "export SCHRODINGER=$schrodinger_path\n\n";

    print OUT "mkdir /tmp/$user\n";
    print OUT "rm -r /tmp/$user/$name-$id\n";
    print OUT "cp -r $output/$name/mol_tmp/$id /tmp/$user/$name-$id\n";
    print OUT "$para_script/mol_convert.pl /tmp/$user/$name-$id\n";
    print OUT "mv /tmp/$user/$name-$id $output/$name/decoys/$id\n";
#    print OUT "rm -r $output/$name/mol_tmp/$id\n";	# could uncomment it to delete temporary directory, but not the parent dir mol_tmp, also the sge_tmp
}

if ($filecheck eq "File")
{
    die "All sge scripts of generating opls 2005 parameter for $output/$name/mol_tmp have been generated in $output/$name/sge_tmp !\n";
}

print ">>>>>>>>>> Submitting Job Now ..........\n";
$i = 0;
$n = @dir;
foreach $id (@dir)
{
    $i ++;
    print ">>>>> submitting job para_$name-$id ($i/$n) .....\n";
    `qsub -q $queue -pe $queue 1 $output/$name/sge_tmp/para_$name-$id.sge.sh`;
    `sleep 1`;
}

print "All Your Job Has Been Submitted !\n";
print "Results Will Be Saved at: $output/$name/decoys !\n";
print "Please Remove TMP File $output/$name/sge_tmp and $output/$name/mol_tmp after All JOBS Done !\n";
print "And Generate File: rec_h_opt.pdb and rec_h_opt.log in $output/$name .\n";
print "Good Luck for your next rescoring!\n";
