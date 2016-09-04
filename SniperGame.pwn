#include <a_samp>
#include <ocmd>

forward FunktionSniperTimer(playerid);
forward SniperSpielVorschau(playerid);
forward SniperSpielStart(playerid);
forward SniperSpielWaffe(playerid);
forward SniperTextDrawsLaden(playerid);

#define HELLBLAU 0x00FFFFFF
#define GRAUWEISS 0xEEEEEEFF

new Sniper_Spiel;
new InSS[MAX_PLAYERS];
new AnzahlSniper = 0;
new SniperID[MAX_PLAYERS] = -1;
new SniperPID[15] = -2;
new Sniper_Timer = 180;
new PlayerText:SniperTextDraw[MAX_PLAYERS][44];
new SniperName[MAX_PLAYERS][MAX_PLAYER_NAME];
new SniperPunkte[MAX_PLAYERS] = 0;
new ActorIDs[50];
new ActorSkins[50];
new TargetActor;
new SniperTimerID;
new Float:RandomActorSpawns[50][3] =
{
    	{1588.9060,-1258.7468,277.8810},
	{1581.4366,-1260.9514,277.8815},
	{1574.6543,-1263.1600,277.8828},
	{1568.1713,-1261.8356,277.8828},
	{1563.1342,-1262.2349,277.8828},
	{1556.9232,-1262.0468,277.8828},
	{1559.6361,-1252.3110,277.8794},
	{1569.7833,-1248.8389,277.8785},
	{1577.5448,-1250.8594,277.8790},
	{1585.8676,-1250.8744,277.8790},
	{1592.4263,-1248.9050,277.8785},
	{1589.4852,-1243.9679,277.8773},
	{1582.5509,-1243.2260,277.8772},
	{1574.9615,-1242.8961,277.8771},
	{1566.7104,-1242.5258,277.8770},
	{1559.0293,-1243.0305,277.8806},
	{1553.8767,-1243.0016,277.8819},
	{1556.4637,-1235.5779,277.8812},
	{1565.5957,-1235.8384,277.8790},
	{1572.7388,-1237.6288,277.8758},
	{1580.8700,-1236.7567,277.8756},
	{1588.5568,-1235.8398,277.8754},
	{1591.9213,-1230.1316,277.8740},
	{1586.2651,-1229.0502,277.8737},
	{1581.8055,-1227.6945,277.8751},
	{1574.5583,-1227.0619,277.8768},
	{1567.3706,-1227.5300,277.8786},
	{1562.6019,-1225.1862,277.8797},
	{1557.6360,-1224.1738,277.8809},
	{1551.6621,-1225.2787,277.8824},
	{1544.1647,-1224.5464,261.5938},
	{1547.2034,-1232.2021,261.5933},
	{1545.5525,-1238.6506,261.5938},
	{1543.6647,-1242.3093,261.5938},
	{1547.1328,-1247.4792,261.5933},
	{1545.6599,-1256.0415,261.5933},
	{1547.5654,-1264.7936,261.5938},
	{1554.1526,-1270.5159,261.5938},
	{1560.0283,-1271.6262,261.5938},
	{1565.8499,-1272.0887,261.5938},
	{1574.5333,-1272.2655,261.5938},
	{1580.6798,-1272.2053,261.5938},
	{1587.3296,-1271.8351,261.5938},
	{1583.7137,-1276.5066,250.6563},
	{1577.6770,-1276.5310,250.6563},
	{1570.8777,-1275.8114,250.6563},
	{1561.9371,-1276.1511,250.6563},
	{1555.5406,-1276.0148,250.6563},
	{1548.4800,-1274.0487,250.6563},
	{1543.8501,-1270.2203,250.6563}
};

//Dialoge
#define SNIPER 3
#define SNIPER2 4

public OnGameModeInit()
{
   	Sniper_Spiel = CreatePickup(1313,1,1369.9866,-949.9156,34.1931,-1);
   	Create3DTextLabel("Sniper",GRAUWEISS,1369.9866,-949.9156,34.5000,30,0,0);
	return 1;
}

public FunktionSniperTimer(playerid)
{
	new string[4];
	format(string,sizeof(string),"%i",Sniper_Timer);
	for(new s=1;s<14;s++)
	{
  		if(SniperPID[s] != -2)
		{
			PlayerTextDrawSetString(SniperPID[s],PlayerText:SniperTextDraw[SniperPID[s]][43],string);
		}
	}
	Sniper_Timer--;
	if(Sniper_Timer == 0)
	{
        	Sniper_Timer = 180;
        	KillTimer(SniperTimerID);
        	new var = 1;
		for(new i=1;i<14;i++)
		{
            		if(SniperPunkte[SniperPID[i]] > SniperPunkte[SniperPID[var]])
        		{
 				var = i;
            		}
		}
		new string2[128];
		format(string2,sizeof(string2),"%s hat die Runde mit %i Punkten gewonnen",SniperName[SniperPID[var]],SniperPunkte[SniperPID[var]]);
		SendClientMessageToAll(HELLBLAU,string2);
		for(new k=1; k<14; k++)
		{
			SniperPunkte[k] = 0;
			if(SniperPID[k] != -2)
			{
				SetPlayerPos(SniperPID[k],1372.0284,-939.6686,34.1875);
				SetPlayerVirtualWorld(SniperPID[k],0);
				InSS[SniperPID[k]] = 0;
				SetPlayerTeam(SniperPID[k],NO_TEAM);
				SniperName[SniperPID[k]] = "Frei";
				SniperPunkte[SniperPID[k]] = 0;
				AnzahlSniper = 0;
				ResetPlayerWeapons(SniperPID[k]);
				new iwas = 1+k;
				if(iwas > 3 && iwas < 17) iwas = iwas+13;
				PlayerTextDrawSetString(SniperPID[k],PlayerText:SniperTextDraw[SniperPID[k]][iwas],"Frei");
				PlayerTextDrawSetString(SniperPID[k],PlayerText:SniperTextDraw[SniperPID[k]][27+k],"0");
 				for(new i=0;i<44;i++)
				{
					PlayerTextDrawHide(SniperPID[k],PlayerText:SniperTextDraw[SniperPID[k]][i]);
				}
				SniperID[SniperPID[k]] = -1;
				SniperPID[k] = -2;
			}
			for(new a=0; a < 50; a++)
			{
			    DestroyActor(ActorIDs[a]);
			}
            	DestroyActor(TargetActor);
		}
	}
	return 1;
}

public SniperTextDrawsLaden(playerid)
{
	//Textdraws Sniper
	SniperTextDraw[playerid][0] = CreatePlayerTextDraw(playerid,2.000000, 117.199905, "_~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][0], 0.400000, 1.600000);
	PlayerTextDrawTextSize(playerid,SniperTextDraw[playerid][0], 94.000000, 0.000000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][0], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][0], -1);
	PlayerTextDrawUseBox(playerid,SniperTextDraw[playerid][0], 1);
	PlayerTextDrawBoxColor(playerid,SniperTextDraw[playerid][0], 0x00000055);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][0], 0x00000055);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][0], 0);

	SniperTextDraw[playerid][1] = CreatePlayerTextDraw(playerid,2.000000, 114.288795, "Spieler_-_Punkte");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][1], 0.345000, 1.863110);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][1], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][1], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][1], 0);

	SniperTextDraw[playerid][2] = CreatePlayerTextDraw(playerid,1.300000, 135.866638, "Frei");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][2], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][2], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][2], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][2], 0);

	SniperTextDraw[playerid][3] = CreatePlayerTextDraw(playerid,1.300000, 156.467895, "Frei");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][3], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][3], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][3], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][3], 0);

	SniperTextDraw[playerid][4] = CreatePlayerTextDraw(playerid,-5.000000, 185.258972, "------------------");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][4], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][4], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][4], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][4], 0);

	SniperTextDraw[playerid][5] = CreatePlayerTextDraw(playerid,-5.000000, 205.060180, "------------------");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][5], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][5], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][5], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][5], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][5], 0);

	SniperTextDraw[playerid][6] = CreatePlayerTextDraw(playerid,-5.000000, 225.061401, "------------------");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][6], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][6], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][6], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][6], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][6], 0);

	SniperTextDraw[playerid][7] = CreatePlayerTextDraw(playerid,-5.000000, 245.062622, "------------------");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][7], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][7], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][7], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][7], 0);

	SniperTextDraw[playerid][8] = CreatePlayerTextDraw(playerid,-5.000000, 265.063842, "------------------");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][8], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][8], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][8], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][8], 0);

	SniperTextDraw[playerid][9] = CreatePlayerTextDraw(playerid,-5.000000, 285.065063, "------------------");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][9], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][9], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][9], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][9], 0);

	SniperTextDraw[playerid][10] = CreatePlayerTextDraw(playerid,-5.000000, 305.066284, "------------------");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][10], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][10], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][10], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][10], 0);

	SniperTextDraw[playerid][11] = CreatePlayerTextDraw(playerid,-5.000000, 325.067504, "------------------");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][11], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][11], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][11], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][11], 0);

	SniperTextDraw[playerid][12] = CreatePlayerTextDraw(playerid,-5.000000, 345.068725, "------------------");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][12], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][12], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][12], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][12], 0);

	SniperTextDraw[playerid][13] = CreatePlayerTextDraw(playerid,-5.000000, 365.069946, "------------------");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][13], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][13], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][13], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][13], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][13], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][13], 0);

	SniperTextDraw[playerid][14] = CreatePlayerTextDraw(playerid,-5.000000, 165.057739, "------------------");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][14], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][14], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][14], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][14], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][14], 0);

	SniperTextDraw[playerid][15] = CreatePlayerTextDraw(playerid,-5.000000, 145.056518, "------------------");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][15], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][15], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][15], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][15], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][15], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][15], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][15], 0);

	SniperTextDraw[playerid][16] = CreatePlayerTextDraw(playerid,-5.000000, 125.055526, "------------------");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][16], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][16], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][16], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][16], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][16], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][16], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][16], 0);

 	SniperTextDraw[playerid][17] = CreatePlayerTextDraw(playerid,1.300000, 175.769073, "Frei");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][17], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][17], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][17], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][17], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][17], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][17], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][17], 0);

	SniperTextDraw[playerid][18] = CreatePlayerTextDraw(playerid,1.300000, 196.570343, "Frei");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][18], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][18], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][18], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][18], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][18], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][18], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][18], 0);

	SniperTextDraw[playerid][19] = CreatePlayerTextDraw(playerid,1.300000, 215.771514, "Frei");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][19], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][19], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][19], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][19], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][19], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][19], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][19], 0);

	SniperTextDraw[playerid][20] = CreatePlayerTextDraw(playerid,1.300000, 235.572723, "Frei");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][20], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][20], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][20], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][20], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][20], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][20], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][20], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][20], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][20], 0);

	SniperTextDraw[playerid][21] = CreatePlayerTextDraw(playerid,1.300000, 255.473937, "Frei");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][21], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][21], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][21], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][21], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][21], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][21], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][21], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][21], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][21], 0);

	SniperTextDraw[playerid][22] = CreatePlayerTextDraw(playerid,1.300000, 276.175201, "Frei");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][22], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][22], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][22], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][22], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][22], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][22], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][22], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][22], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][22], 0);

	SniperTextDraw[playerid][23] = CreatePlayerTextDraw(playerid,1.300000, 296.076416, "Frei");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][23], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][23], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][23], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][23], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][23], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][23], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][23], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][23], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][23], 0);

	SniperTextDraw[playerid][24] = CreatePlayerTextDraw(playerid,1.300000, 315.977630, "Frei");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][24], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][24], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][24], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][24], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][24], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][24], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][24], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][24], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][24], 0);

	SniperTextDraw[playerid][25] = CreatePlayerTextDraw(playerid,1.300000, 335.978851, "Frei");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][25], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][25], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][25], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][25], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][25], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][25], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][25], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][25], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][25], 0);

	SniperTextDraw[playerid][26] = CreatePlayerTextDraw(playerid,1.300000, 355.980072, "Frei");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][26], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][26], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][26], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][26], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][26], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][26], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][26], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][26], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][26], 0);

	SniperTextDraw[playerid][27] = CreatePlayerTextDraw(playerid,1.300000, 375.681274, "Frei");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][27], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][27], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][27], -1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][27], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][27], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][27], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][27], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][27], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][27], 0);

	SniperTextDraw[playerid][28] = CreatePlayerTextDraw(playerid,93.500000, 136.488830, "0");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][28], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][28], 3);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][28], -16776961);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][28], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][28], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][28], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][28], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][28], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][28], 0);

	SniperTextDraw[playerid][29] = CreatePlayerTextDraw(playerid,93.500000, 156.290039, "0");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][29], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][29], 3);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][29], -16776961);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][29], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][29], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][29], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][29], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][29], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][29], 0);

	SniperTextDraw[playerid][30] = CreatePlayerTextDraw(playerid,93.500000, 175.891235, "0");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][30], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][30], 3);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][30], -16776961);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][30], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][30], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][30], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][30], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][30], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][30], 0);

	SniperTextDraw[playerid][31] = CreatePlayerTextDraw(playerid,93.500000, 195.892456, "0");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][31], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][31], 3);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][31], -16776961);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][31], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][31], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][31], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][31], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][31], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][31], 0);

	SniperTextDraw[playerid][32] = CreatePlayerTextDraw(playerid,93.500000, 216.093688, "0");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][32], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][32], 3);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][32], -16776961);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][32], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][32], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][32], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][32], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][32], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][32], 0);

	SniperTextDraw[playerid][33] = CreatePlayerTextDraw(playerid,93.500000, 236.094909, "0");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][33], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][33], 3);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][33], -16776961);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][33], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][33], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][33], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][33], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][33], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][33], 0);

	SniperTextDraw[playerid][34] = CreatePlayerTextDraw(playerid,93.500000, 256.496154, "0");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][34], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][34], 3);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][34], -16776961);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][34], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][34], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][34], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][34], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][34], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][34], 0);

	SniperTextDraw[playerid][35] = CreatePlayerTextDraw(playerid,93.500000, 275.797332, "0");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][35], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][35], 3);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][35], -16776961);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][35], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][35], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][35], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][35], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][35], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][35], 0);

	SniperTextDraw[playerid][36] = CreatePlayerTextDraw(playerid,93.500000, 295.798553, "0");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][36], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][36], 3);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][36], -16776961);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][36], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][36], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][36], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][36], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][36], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][36], 0);

	SniperTextDraw[playerid][37] = CreatePlayerTextDraw(playerid,93.500000, 315.999786, "0");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][37], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][37], 3);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][37], -16776961);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][37], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][37], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][37], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][37], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][37], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][37], 0);

	SniperTextDraw[playerid][38] = CreatePlayerTextDraw(playerid,93.500000, 336.101013, "0");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][38], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][38], 3);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][38], -16776961);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][38], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][38], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][38], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][38], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][38], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][38], 0);

	SniperTextDraw[playerid][39] = CreatePlayerTextDraw(playerid,93.500000, 356.902282, "0");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][39], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][39], 3);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][39], -16776961);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][39], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][39], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][39], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][39], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][39], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][39], 0);

	SniperTextDraw[playerid][40] = CreatePlayerTextDraw(playerid,93.500000, 376.103454, "0");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][40], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][40], 3);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][40], -16776961);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][40], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][40], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][40], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][40], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][40], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][40], 0);

	SniperTextDraw[playerid][41] = CreatePlayerTextDraw(playerid,295.500000, 0.844415, "_~n~_");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][41], 0.400000, 1.600000);
	PlayerTextDrawTextSize(playerid,SniperTextDraw[playerid][41], 351.000000, 0.000000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][41], 1);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][41], -1);
	PlayerTextDrawUseBox(playerid,SniperTextDraw[playerid][41], 1);
	PlayerTextDrawBoxColor(playerid,SniperTextDraw[playerid][41], 0x00000055);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][41], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][41], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][41], 0x00000055);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][41], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][41], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][41], 0);

	SniperTextDraw[playerid][42] = CreatePlayerTextDraw(playerid,323.500000, 0.222213, "Zeit:~n~");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][42], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][42], 2);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][42], 16777215);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][42], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][42], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][42], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][42], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][42], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][42], 0);

	SniperTextDraw[playerid][43] = CreatePlayerTextDraw(playerid,323.500000, 13.622230, "180");
	PlayerTextDrawLetterSize(playerid,SniperTextDraw[playerid][43], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid,SniperTextDraw[playerid][43], 2);
	PlayerTextDrawColor(playerid,SniperTextDraw[playerid][43], 16777215);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][43], 0);
	PlayerTextDrawSetOutline(playerid,SniperTextDraw[playerid][43], 0);
	PlayerTextDrawBackgroundColor(playerid,SniperTextDraw[playerid][43], 255);
	PlayerTextDrawFont(playerid,SniperTextDraw[playerid][43], 1);
	PlayerTextDrawSetProportional(playerid,SniperTextDraw[playerid][43], 1);
	PlayerTextDrawSetShadow(playerid,SniperTextDraw[playerid][43], 0);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	InSS[playerid]=0;
	SniperName[playerid] = "Frei";
	SniperPunkte[playerid] = 0;
	SniperPID[SniperID[playerid]] = -2;
	SniperID[playerid] = -1;
    	SetPlayerTeam(playerid, 0);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(InSS[playerid] == 1)
	{
		SetPlayerPos(playerid,1544.6697,-1340.0653,328.2372);
		SetPlayerFacingAngle(playerid,0.5248);
		SetPlayerVirtualWorld(playerid,2);
		GivePlayerWeapon(playerid,34,1000);
	}
	return 1;
}

ocmd:joinsniper(playerid,params[])
{
	if(InSS[playerid] == 0)
	{
		if(AnzahlSniper == 0)
		{
		    SendClientMessage(playerid,HELLBLAU,"Derzeit ist kein Sniper-Spiel geöffnet");
		    return 1;
		}
		SetPlayerPos(playerid,1544.6697,-1340.0653,328.2372);
		SetPlayerFacingAngle(playerid,0.5248);
		SetPlayerVirtualWorld(playerid,2);
		CallLocalFunction("SniperTextDrawsLaden","i",playerid);
		InSS[playerid] = 1;
		GetPlayerName(playerid,SniperName[playerid],sizeof(SniperName));
		if(AnzahlSniper == 0)
		{
			Sniper_Timer = 200;
			SendClientMessage(playerid,HELLBLAU,"Das Spiel startet in 20 Sekunden");
			new string[24+MAX_PLAYER_NAME];
			new Nachricht[128] = "hat eine Sniper-Runde eröffnet";
			format(string,sizeof(string),"%s %s",SniperName[playerid],Nachricht);
			SendClientMessageToAll(HELLBLAU, string);
			SendClientMessageToAll(HELLBLAU, "Gebe /joinsniper ein, um dem Spiel beizutreten");
			SetTimerEx("SniperSpielVorschau",20000,false,"i",playerid);
			SniperTimerID = SetTimerEx("FunktionSniperTimer",1000,true,"i",playerid);
		}
		AnzahlSniper++;
		SetPlayerTeam(playerid,3);
		for(new i=0;i<44;i++)
		{
			PlayerTextDrawShow(playerid,PlayerText:SniperTextDraw[playerid][i]);
		}
		new string[24+MAX_PLAYER_NAME];
		format(string,sizeof(string),"%s",SniperName[playerid]);
		new iwas = 1+SniperID[playerid];
		if(iwas > 3 && iwas < 17) iwas = iwas+13;
		for(new s=0;s<14;s++)
		{
			PlayerTextDrawSetString(SniperPID[s],PlayerText:SniperTextDraw[SniperPID[s]][iwas],string);
		}
	}
	return 1;
}


ocmd:leavesniper(playerid,params[])
{
	if(AnzahlSniper > 1)
	{
		SniperPunkte[playerid] = 0;
		SetPlayerPos(playerid,1372.0284,-939.6686,34.1875);
		SetPlayerVirtualWorld(playerid,0);
		InSS[playerid] = 0;
		SetPlayerTeam(playerid,NO_TEAM);
		SniperName[playerid] = "Frei";
		SniperPunkte[playerid] = 0;
		AnzahlSniper--;
		ResetPlayerWeapons(playerid);
		new iwas = 1+SniperID[playerid];
		if(iwas > 3 && iwas < 17) iwas = iwas+13;
		PlayerTextDrawSetString(playerid,PlayerText:SniperTextDraw[playerid][iwas],"Frei");
		PlayerTextDrawSetString(playerid,PlayerText:SniperTextDraw[playerid][27+SniperID[playerid]],"0");
		for(new i=0;i<44;i++)
		{
			PlayerTextDrawHide(playerid,PlayerText:SniperTextDraw[playerid][i]);
		}
        	SniperPID[SniperID[playerid]] = -2;
		SniperID[playerid] = -1;
	}
	if(AnzahlSniper == 1)
	{
		Sniper_Timer = 180;
	    	KillTimer(SniperTimerID);
	    	new var = 1;
		for(new i=1;i<14;i++)
		{
	        	if(SniperPunkte[SniperPID[i]] > SniperPunkte[SniperPID[var]])
	        	{
				var = i;
	        	}
		}
		new string2[128];
		format(string2,sizeof(string2),"%s hat die Runde mit %i Punkten gewonnen",SniperName[SniperPID[var]],SniperPunkte[SniperPID[var]]);
		SendClientMessageToAll(HELLBLAU,string2);
		for(new k=1; k<14; k++)
		{
			SniperPunkte[k] = 0;
			if(SniperPID[k] != -2)
			{
				SetPlayerPos(SniperPID[k],1372.0284,-939.6686,34.1875);
				SetPlayerVirtualWorld(SniperPID[k],0);
				InSS[SniperPID[k]] = 0;
				SetPlayerTeam(SniperPID[k],NO_TEAM);
				SniperName[SniperPID[k]] = "Frei";
				SniperPunkte[SniperPID[k]] = 0;
				AnzahlSniper = 0;
				ResetPlayerWeapons(SniperPID[k]);
				new iwas = 1+k;
				if(iwas > 3 && iwas < 17) iwas = iwas+13;
				PlayerTextDrawSetString(SniperPID[k],PlayerText:SniperTextDraw[SniperPID[k]][iwas],"Frei");
				PlayerTextDrawSetString(SniperPID[k],PlayerText:SniperTextDraw[SniperPID[k]][27+k],"0");
				for(new i=0;i<44;i++)
				{
					PlayerTextDrawHide(SniperPID[k],PlayerText:SniperTextDraw[SniperPID[k]][i]);
				}
				SniperID[SniperPID[k]] = -1;
				SniperPID[k] = -2;
			}
			for(new a=0; a < 50; a++)
			{
			    DestroyActor(ActorIDs[a]);
			}
	        DestroyActor(TargetActor);
		}
	}
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	if(pickupid == Sniper_Spiel)
	{
	    ShowPlayerDialog(playerid,SNIPER,DIALOG_STYLE_LIST,"SNIPER","Map 1 (Startower)","Bestätigen","Abbrechen");
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == SNIPER)
	{
		if(response == 0)
		{
		    return 1;
		}
		if(listitem == 0)
		{
		    ShowPlayerDialog(playerid,SNIPER2,DIALOG_STYLE_LIST,"Schwierigkeit","Leicht","Bestätigen","Abbrechen");
		}
	}
	if(dialogid == SNIPER2)
	{
		if(response == 0)
		{
		    return 1;
		}
		if(listitem == 0)
		{
			if(AnzahlSniper > 10)
			{
			    SendClientMessage(playerid,HELLBLAU,"Tut mir leid, das Spiel ist voll.");
			}
			if(AnzahlSniper < 11)
			{
				SetPlayerPos(playerid,1544.6697,-1340.0653,328.2372);
				CallLocalFunction("SniperTextDrawsLaden","i",playerid);
		 		SetPlayerFacingAngle(playerid,0.5248);
		 		SetPlayerVirtualWorld(playerid,2);
				InSS[playerid] = 1;
				SniperID[playerid] = 1+AnzahlSniper;
				SniperPID[SniperID[playerid]] = playerid;
				GetPlayerName(playerid,SniperName[playerid],sizeof(SniperName));
				if(AnzahlSniper == 0)
				{
					Sniper_Timer = 200;
					for(new i=0; i < 50; i++)
					{
			    		DestroyActor(ActorIDs[i]);
					}
            				DestroyActor(TargetActor);
					new string[24+MAX_PLAYER_NAME];
					new Nachricht[128] = "hat eine Sniper-Runde eröffnet";
					format(string,sizeof(string),"%s %s",SniperName[playerid],Nachricht);
					SendClientMessageToAll(HELLBLAU, string);
					SendClientMessageToAll(HELLBLAU, "Gebe /joinsniper ein, um dem Spiel beizutreten");
					SendClientMessage(playerid,HELLBLAU,"Das Spiel startet in 20 Sekunden");
					SetTimerEx("SniperSpielVorschau",20000,false,"i",playerid);
					SniperTimerID = SetTimerEx("FunktionSniperTimer",1000,true,"i",playerid);
				}
				AnzahlSniper++;
				SetPlayerTeam(playerid,3);
				for(new i=0;i<44;i++)
				{
					PlayerTextDrawShow(playerid,SniperTextDraw[playerid][i]);
				}
				new string[24+MAX_PLAYER_NAME];
				format(string,sizeof(string),"%s",SniperName[playerid]);
				for(new s=1;s<1+AnzahlSniper;s++)
				{
					if(SniperPID[s] != -2)
					{
						new iwas = 1+s;
						if(iwas > 3 && iwas < 17) iwas = iwas+13;
						PlayerTextDrawSetString(SniperPID[s],PlayerText:SniperTextDraw[SniperPID[s]][iwas],string);
					}
				}
			}
		}
	}

	return 1;
}

public SniperSpielVorschau(playerid)
{
	new RandomTargetActorSkin = random(311);
 	new ActorZumEntbuggen; //Erster Actor In Neuer Public Funktion Hat Die ID Null Selbst Wenn Diese Bereits Existiert Deshalb Zum Entbuggen Hier Ein Actor Der Nicht Benutzt Wird #FuckThisShit #GoPatchItSAMP
 	ActorZumEntbuggen = CreateActor(0,0,0,0,0);
	IsValidActor(ActorZumEntbuggen); //Damit kein NeverUsed Warning kommt
	TargetActor = CreateActor(RandomTargetActorSkin,1544.5718,-1337.7959,328.2183,172.6574);
	SetActorVirtualWorld(TargetActor,2);
	SetActorInvulnerable(TargetActor,false);
	for(new i=0;i<50;i++)
	{
		ActorSkins[i] = random(310);
		for(new k=0; k != i; k++)
		{
			if(ActorSkins[i] == ActorSkins[k])
			{
   				ActorSkins[i]++;
			}
			if(ActorSkins[i]+1 == ActorSkins[k])
			{
			    ActorSkins[i]++;
			    ActorSkins[i]++;
			}
			if(ActorSkins[i]+2 == ActorSkins[k])
			{
			    ActorSkins[i]++;
			    ActorSkins[i]++;
			    ActorSkins[i]++;
			}
		}
		if(ActorSkins[i] == RandomTargetActorSkin)
		{
		    ActorSkins[i]++;
		}
		ActorIDs[i] = CreateActor(ActorSkins[i],RandomActorSpawns[i][0],RandomActorSpawns[i][1],RandomActorSpawns[i][2],0);
		SetActorVirtualWorld(ActorIDs[i],2);
		SetActorFacingAngle(ActorIDs[i],172.6574);
		SetActorInvulnerable(ActorIDs[i],false);
	}
	ResetPlayerWeapons(playerid);
	SetTimerEx("SniperSpielStart",5000, false,"i",playerid);
	SetTimerEx("SniperSpielWaffe",6000, false,"i",playerid);
	return 1;
}

public SniperSpielWaffe(playerid)
{
    	GivePlayerWeapon(playerid,34,1000);
	return 1;
}

public SniperSpielStart(playerid)
{
	new Random = random(sizeof(RandomActorSpawns));
	SetActorPos(TargetActor,RandomActorSpawns[Random][0],RandomActorSpawns[Random][1],RandomActorSpawns[Random][2]);
	SetActorInvulnerable(TargetActor, false);
	SetActorFacingAngle(TargetActor,172.6574);
	for(new k=0; k < 50; k++)
	{
		new Float:Xk,Float:Yk,Float:Zk;
		GetActorPos(ActorIDs[k],Xk,Yk,Zk);
		new Float:Tx,Float:Ty,Float:Tz;
		GetActorPos(TargetActor,Tx,Ty,Tz);
		if(Tx == Xk)
			{
			    if(Ty == Yk)
			    {
					DestroyActor(ActorIDs[k]);
			    }
			}
	}
	return 1;
}

public OnPlayerGiveDamageActor(playerid, damaged_actorid, Float: amount, weaponid, bodypart)
{
	if(damaged_actorid == TargetActor)
	{
		new Float:X,Float:Y,Float:Z;
		new Float:VorschauX,Float:VorschauY,Float:VorschauZ;
		VorschauX = 1544.5718;
		VorschauY = -1337.7959;
		VorschauZ = 328.2183;
		GetActorPos(TargetActor,X,Y,Z);
		if(X == VorschauX)
		{
		    	if(Y == VorschauY)
			{
		        	if(Z == VorschauZ)
				{
					for(new i=0; i < 50; i++)
					{
					    SniperPunkte[playerid]--;
					}
				}
			}
		}
		if (X != VorschauX)
		{
			if(bodypart == 9) //Kopftreffer
			{
				for(new i=0; i < 100; i++)
				{
					SniperPunkte[playerid]++;
				}
			}
			if(bodypart != 9)
			{
				for(new i=0; i < 50; i++)
				{
					SniperPunkte[playerid]++;
				}
			}
			for(new i=0; i < 50; i++)
			{
			    DestroyActor(ActorIDs[i]);
			}
            		DestroyActor(TargetActor);
			if(InSS[playerid] == 1)
			{
				SetTimerEx("SniperSpielVorschau",1000,false,"i",playerid);
			}
		}
	}
	else
	{
		for(new i=0; i < 50; i++)
		{
			SniperPunkte[playerid]--;
		}
	}

    	new string[10];
	format(string,sizeof(string),"%i",SniperPunkte[playerid]);
	for(new s=1;s<14;s++)
	{
		if(SniperPID[s] != -2)PlayerTextDrawSetString(SniperPID[s],PlayerText:SniperTextDraw[SniperPID[s]][27+AnzahlSniper],string);
	}
	return 1;
}
