#!/bin/bash
fig_fmt=jpg
fig_fmt=pdf
fig_name=Figure1.1_globalMap
datapath=../../../../data_project
source ~/OneDrive/codeCenter/GMTstarter.sh
gmt set MAP_FRAME_TYPE=fancy

earthquake=$datapath/seismic/USGS
ridgepath=$datapath/ridge_hotspot
inf=$datapath/topo_global/earth_relief_10m.grd
grad=$datapath/topo_global/grad_relief_10m-0.8.nc

age=$datapath/age/age.2020.1.GTS2012.6m.nc
grad_age=$datapath/age/grad_age.2020.1.GTS2012.6m.nc

spreadingRate=$datapath/age/full_rate.2020.1.GTS2012.6m.nc
grad_spreadingRate=$datapath/age/grad_full_rate.2020.1.GTS2012.6m.nc
HF=$datapath/HeatFlow/HeatFlow_Lucazeau2019.grd
# gmt grdgradient $inf -G$grad -A45/45 -Nt0.8 -fg
# gmt grdgradient $age -G$grad_age -A45/45 -Nt0.6 -fg
# gmt grdgradient $spreadingRate -G$grad_spreadingRate -A45/45 -Nt0.6 -fg
# gmt grdclip $inf -Gnew_grd.nc -Sa0/NaN

addfeatures()
{
    gmt plot $ridgepath/ridge/ultra_*.txt     -W1p
    gmt plot $ridgepath/ridge/slow_*.txt     -W1p
    gmt plot $ridgepath/ridge/inter_*.txt     -W1p
    gmt plot $ridgepath/ridge/fast_*.txt     -W1p
    gmt plot -T -Bg45
}

addname()
{
    echo 45  -49  SWIR | gmt text -F+f10,Helvetica-Bold=~1p,white+jLM+a30
    echo 80  -35  SEIR | gmt text  -F+f10,Helvetica-Bold=~1p,white+jLM+a-54
    echo 71  -10  CIR  | gmt text  -F+f10,Helvetica-Bold=~1p,white+jLM+a-100 
    echo 55   7  CaR   | gmt text  -F+f10,Helvetica-Bold=~1p,white+jLM+a-50
    echo -20  4 MAR  | gmt text  -F+f10,Helvetica-Bold=~1p,white+jCM+a-2
    echo -15  -63 AAR  | gmt text  -F+f10,Helvetica-Bold=~1p,white+jCM+a15
    echo -108 5 EPR  | gmt text  -F+f10,Helvetica-Bold=~1p,white+jCM+a90 
    echo -140 48 JdFR  | gmt text  -F+f10,Helvetica-Bold=~1p,white+jCM+a36
    echo -93 6 GSC  | gmt text  -F+f10,Helvetica-Bold=~1p,white+jCM
    echo -93 -33 ChR  | gmt text  -F+f10,Helvetica-Bold=~1p,white+jCM+a-13
    echo -120 -46 PAR  | gmt text  -F+f10,Helvetica-Bold=~1p,white+jCM+a-50
    echo 43 81 AR | gmt text -F+f10,Helvetica-Bold=~1p,white+jLM
}

Bx=a0.5f0.25
By=a0.5f0.25
R=-180/180/-90/90
J=H18c
cpt_topo=world_nasa.cpt
cpt_age=$datapath/age/cpt_age/age_2020.cpt
cpt_rate=$datapath/age/cpt_age/fullrategrid.cpt
color_bar="-Dx3c/-1.3c+w12c/0.4c+ml+h --MAP_FRAME_PEN=0.5p --MAP_TICK_LENGTH=0.15 --MAP_ANNOT_OFFSET_PRIMARY=0.1"


gmt begin $fig_name $fig_fmt 
#----topography -------#----topography -------#----topography -------#----topography -------#----topography -------#----topography -------
gmt plot -T -R$R -J$J -Btblr -Y30c
echo \(a\) | gmt text -F+f22p+cTL -D0.5c/-0.5c
gmt grdimage $inf -I$grad -C$cpt_topo  
addfeatures
addname
gmt psscale -C$cpt_topo -Bxa3000f1000+l"Totography (m)"  -Dx12.5c/-0.6c+w12c/0.4c+ml+h --MAP_FRAME_PEN=0.5p --MAP_TICK_LENGTH=0.15 --MAP_ANNOT_OFFSET_PRIMARY=0.1  -I

# gmt end show
# exit
#----teleseismic -------#----teleseismic -------#----teleseismic -------#----teleseismic -------#----teleseismic -------#----teleseismic -------
gmt plot -T -X19c
gmt basemap -R$R -J$J -Btblr 
echo \(b\) | gmt text -F+f22p+cTL -D0.5c/-0.5c
gmt grdimage $inf -I$grad  -C$cpt_topo 
gmt plot $earthquake/*.csv -i2,1 -Sp1.5p 
gmt plot -T -Bg45
addname
gmt plot -T -X-19c 

#----age -------#----age -------#----age -------#----age -------#----age -------#----age -------#----age -------#----age -------
gmt plot -T -Y-10.8c
gmt basemap -R$R -J$J -Btblr 
echo \(c\) | gmt text -F+f22p+cTL -D0.5c/-0.5c
gmt grdimage $age -I$grad_age -C$cpt_age 
gmt coast -A10000   -G253/249/211 -Dh
addfeatures
addname
gmt psscale -C$cpt_age -Bxa50f10+l"Age of Oceanic Crust (Myr)" $color_bar

#----Heat flow------#----spreading rate------#----spreading rate------#----spreading rate------#----spreading rate------
gmt plot -T -X19c
gmt makecpt -Crainbow -T40/120/10 -D -F -Z
gmt grdsample $HF -Ghigh_HF.nc -I5m -R$HF
gmt basemap -R$R -J$J -Btblr 
echo \(d\) | gmt text -F+f22p+cTL -D0.5c/-0.5c
gmt grdimage high_HF.nc -C
gmt coast -A10000  -G253/249/211 -Dh
addfeatures
addname
gmt psscale -C -Bxa20f10+l"Heat flow (mWm@+-2@+)" $color_bar
rm high_HF.nc

gmt end show
rm gmt.* 
# rm new_grd.nc # remove gmt files
