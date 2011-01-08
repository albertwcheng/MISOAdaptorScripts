scriptDir=`pwd`

cd ..

sourceTableSubPath=Combined-1.00 #use the most redundant one
seqTableSubPath=seq.merged.xls #this is the seq.merged.xls with header
seqTableSubPath2=seq.merged.highlyRedundant #this is the seq.merged without header

if [ -e EventGff ]; then
	rm -Rf EventGff
fi


mkdir EventGff



for eventType in SE MXE A5SS A3SS A3UTR AFE ALE RI; do
	Splidar.Splicing.EventBEDMaker.py --track-name $eventType --colors "255,0,0_0,0,255" $eventType/$sourceTableSubPath .eventType,.locusName,.eventID .chr .strand ".inc/excBound" >  EventGff/${eventType}.ebed
	ebed2GenePred.py --fs " "  EventGff/${eventType}.ebed > EventGff/${eventType}.genePred
	RefGeneTable2sGFF3.py --source "Splidar.$eventType" --replace "_." --with "@:" --input-is-gene-pred --expand-parents EventGff/${eventType}.genePred > EventGff/${eventType}.pe.gff3
	if [ ! -e EventGff/allEvents.pe.GFF3 ]; then
		cat EventGff/${eventType}.pe.gff3 > EventGff/allEvents.pe.GFF3  #first one with header
		cat $eventType/$seqTableSubPath > EventGff/allEvents.SEQ.TAB    #first one with header
	else
		awk 'FNR>1' EventGff/${eventType}.pe.gff3 >> EventGff/allEvents.pe.GFF3
		cat $eventType/$seqTableSubPath2 >> EventGff/allEvents.SEQ.TAB
	fi
	cat EventGff/${eventType}.ebed >> EventGff/allEvents.EBED
	cat $eventType/$seqTableSubPath > EventGff/${eventType}.seq.tab

done

#cat EventGff/*.ebed > EventGff/allEvents.EBED

