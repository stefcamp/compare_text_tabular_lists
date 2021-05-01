print "Questo programma confronta N liste tabulate sulla base dei valori della prima colonna, le liste sono elecate una per riga in un file che rappresenta l'unico argomento del programma e vengono appaiate in una matrice\n";
print "ATTENZIONE! LE LISTE NON DEVONO CONTENERE ELEMENTI RIDONDANTI\nLE LISTE DEVO AVERE LO STESSO NUMERO DI COLONNE\n\n";
open (Z, "> liste_sommate.txt"); #file di output

#1#################################
#conto il numero di liste da confrontare
$liste=$ARGV[0];
open (O,"$liste")||die "\n-- Missing file with the lists to be compared --\n"; #lista nomi dei contigs
while ($riga=<O>){
	$i++;
    	chomp $riga;
    	push (@liststobecomp, $riga);
}


#$i=0;
#foreach $riga(@liststobecomp){    $i++;}
#print "\n$i Liste da confrontare @liststobecomp\n";
$numlis=$i;

#2#################################
#Serve un elemento che chiamerò $rigariemp che abbia lo stesso numero di elementi rispetto al numero di colonne
#delle liste cosi che poi possa riempire gli elementi vuoti nella lista globale ad ogni passaggio per mantenere l'appaiamento corretto

print "Inserire il numero di colonne delle liste\n";
$ellis = <STDIN>; #questa variabile contiene il numero di colonne di ogni lista
chomp $ellis;
$ii=0;
$ellis=$ellis-1;
for ($ii=0;$ii<$ellis;$ii++){
    $rigariemp=$rigariemp."#"."\t";
}
$rigariemp=$rigariemp."#"; #questo è l'elemento riempitivo
print "$rigariemp\n";

#3#################################
#Riunire il primo campo di tutte le liste in un unico array in modo da generare un lista unica non ridondante
#su cui poi verranno allineate le altre liste
#per fare questo userò il programma singlefeaturecounter.pl ma senza inserire nell'output il numero di ognuno degli elementi

print "Inizio riunione delle liste\n";
for ($a=0;$a<$i;$a++){
    print "Lista $a\n\n";
    $lis1=$liststobecomp[$a];
    open (U,"$lis1");
    while ($riga=<U>){
	chomp $riga;
        #print "$riga\n";
        
	push (@LISTA0, $riga); #nell'array @LISTA1 c'è il primo elemento della lista
        @array0=split (/\t/,$riga);
        push (@LISTA1, $array0[0]); #nell'array @LISTA1 c'è il primo elemento della lista
        #print "$riga\n";
    }
}
print "Lista iniziale\n@LISTA1\n\n";

print "Generare una lista univoca di nomi dei geni da usare poi per concatenare i singoli esoni del gene\n";
my %counts1;
++$counts1{$_} for @LISTA1;
my @OUTPUT = keys(%counts1);

print "Lista dopo rimozione della ridondanza\n@OUTPUT\n";

#4#################################
#Nell'ultima parte, ciclo su ognuno degli elementi dell'array ARGV e comparo ognuno di essi alla lista totale generata
print "\nInizio l'allineamento delle liste tutte assieme\n";
$a=0;
#$i=0;
#attenzione mi serve un elemento che alla fine di ogni passaggio incrementi e mi consenta di capire quali sono
#le righe su cui non è stato aggiunto nulla perchè non c'era lìelemento corrispondente
for ($a=0;$a<$numlis;$a++){
    print "Passaggio $a\n\n";
    $lis1="";
    @LISTA1=();
    #@notcommon=(); #svuoto l'array dei non comuni
    $lis1=$liststobecomp[$a];
    #print "$lis1\n";
    open (U,"$lis1"); #||die "\n-- Nome file non esistente --\n";
    while ($riga=<U>){
	chomp $riga;
        #print "$riga\n";
	push (@LISTA1, $riga);
    }
    #print "\n\nlista @LISTA1\n\n";
    $count=0; #serve per verificare se c'è match tra le due liste
    foreach $riga2 (@OUTPUT){ #questa è la lista totale
        @arrayout=split (/\t/,$riga2); #devo splittarlo altrimenti dopo il primo passaggio non va più bene
        chomp $riga2;
        $count=0; #serve per verificare se c'è match tra le due liste
        foreach $riga1 (@LISTA1){ #questa è la prima lista che devo appaiare
            chomp $riga1;
            @arrtemp1=split (/\t/,$riga1);
            if ($arrtemp1[0] eq $arrayout[0]){
                $riga2=$riga2."\t".$riga1."\n";
                $count++; #se c'è match tra le due liste il counter viene incrementato e so che devo modificare l'elemento dell'array globale $riga2 aggiungendogli in coda $riga1 cioè la riga della lista che sto appaiando
            }
        }
        if ($count<1){
            $riga2=$riga2."\t".$rigariemp."\n"; #se invece non c'è match allora c'è match allora $count sarà minore di uno e so quindi che devo modificare l'elemento dell'array globale $riga2 aggiungendogli in coda $rigariemp cioè la riga riempitiva coi cancelletto
        }
        #ad ogni ciclo ogni elemento dell'array @OUTPUT viene allungato aggiungendo o l'elemento corrispondente della lista o l'elemento riempitivo
    }
    #print "@OUTPUT\n\n";
}
###################################
print Z @OUTPUT;

