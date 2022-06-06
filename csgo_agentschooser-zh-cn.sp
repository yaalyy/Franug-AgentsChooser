/*  SM Franug CS:GO Agents Chooser
 *
 *  Copyright (C) 2020 Francisco 'Franc1sco' García
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */

#include	<sdktools>
#include	<sdkhooks>
#include	<cstrike>
#include	<clientprefs>

#pragma		semicolon	1
#pragma		newdecls	required

#define		HIDE_CROSSHAIR_CSGO	1<<8
#define		HIDE_RADAR_CSGO		1<<12

Handle	g_hTimer[MAXPLAYERS+1] = null;

// Valve Agents list by category and team
char CTDistinguished[][][] =
{
	{"陆军中尉普里米罗 | 巴西第一营",			"models/player/custom_player/legacy/ctm_st6_variantn.mdl"},
	{"D 中队军官 | 新西兰特种空勤团",							"models/player/custom_player/legacy/ctm_sas_variantg.mdl"},
	{"准尉 | 法国宪兵特勤队",					"models/player/custom_player/legacy/ctm_gendarmerie_variantd.mdl"},
	{"海豹突击队第六分队士兵 | 海军水面战中心海豹部队",						"models/player/custom_player/legacy/ctm_st6_variante.mdl"},
	{"第三特种兵连 | 德国特种部队突击队",							"models/player/custom_player/legacy/ctm_st6_variantk.mdl"},
	{"特种兵 | FBI",									"models/player/custom_player/legacy/ctm_fbi_variantf.mdl"},
	{"B 中队指挥官 | 英国空军特别部队",							"models/player/custom_player/legacy/ctm_sas_variantf.mdl"},
	{"化学防害专家 | SWAT",							"models/player/custom_player/legacy/ctm_swat_variantj.mdl"},
	{"生物防害专家 | SWAT",							"models/player/custom_player/legacy/ctm_swat_varianth.mdl"},
};

char TDistinguished[][][] =
{
	{"捕兽者（挑衅者） | 游击队",				"models/player/custom_player/legacy/tm_jungle_raider_variantf.mdl"},
	{"穆哈里克先生 | 精锐分子",								"models/player/custom_player/legacy/tm_leet_variantj.mdl"},
	{"执行者 | 凤凰战士",									"models/player/custom_player/legacy/tm_phoenix_variantf.mdl"},
	{"枪手 | 凤凰战士",									"models/player/custom_player/legacy/tm_phoenix_varianth.mdl"},
	{"地面叛军 | 精锐分子",							"models/player/custom_player/legacy/tm_leet_variantg.mdl"},
	{"街头士兵 | 凤凰战士",							"models/player/custom_player/legacy/tm_phoenix_varianti.mdl"},
	{"德拉戈米尔 | 军刀勇士",						"models/player/custom_player/legacy/tm_balkan_variantl.mdl"},
};

char CTExceptional[][][] =
{
	{"军官雅克·贝尔特朗 | 法国宪兵特勤队",		"models/player/custom_player/legacy/ctm_gendarmerie_variante.mdl"},
	{"中尉法洛（抱树人） | SWAT",				"models/player/custom_player/legacy/ctm_swat_variantk.mdl"},
	{"军医少尉 | 法国宪兵特勤队",		"models/player/custom_player/legacy/ctm_gendarmerie_varianta.mdl"},
	{"马尔库斯·戴劳 | FBI",									"models/player/custom_player/legacy/ctm_fbi_variantg.mdl"},
	{"铅弹 | 海军水面战中心海豹部队",								"models/player/custom_player/legacy/ctm_st6_variantg.mdl"},
	{"约翰 “范·海伦” 卡斯克 | SWAT",						"models/player/custom_player/legacy/ctm_swat_variantg.mdl"},
	{"军士长炸弹森 | SWAT",								"models/player/custom_player/legacy/ctm_swat_varianti.mdl"},
	{"“蓝莓” 铅弹 | 海军水面战中心海豹部队",					"models/player/custom_player/legacy/ctm_st6_variantj.mdl"},
};

char TExceptional[][][] =
{
	{"上校曼戈斯·达比西 | 游击队",				"models/player/custom_player/legacy/tm_jungle_raider_variantd.mdl"},
	{"捕兽者 | 游击队",							"models/player/custom_player/legacy/tm_jungle_raider_variantf2.mdl"},
	{"马克西姆斯 | 军刀",										"models/player/custom_player/legacy/tm_balkan_varianti.mdl"},
	{"奥西瑞斯 | 精锐分子",									"models/player/custom_player/legacy/tm_leet_varianth.mdl"},
	{"弹弓 | 凤凰战士",									"models/player/custom_player/legacy/tm_phoenix_variantg.mdl"},
	{"德拉戈米尔 | 军刀",									"models/player/custom_player/legacy/tm_balkan_variantf.mdl"},
	{"出逃的萨莉 | 专业人士",					"models/player/custom_player/legacy/tm_professional_varj.mdl"},
	{"小凯夫 | 专业人士",						"models/player/custom_player/legacy/tm_professional_varh.mdl"},
};

char CTSuperior[][][] =
{
	{"化学防害上尉| 法国宪兵特勤队",			"models/player/custom_player/legacy/ctm_gendarmerie_variantb.mdl"},
	{"中尉雷克斯·克里奇 | 海豹蛙人",				"models/player/custom_player/legacy/ctm_diver_variantc.mdl"},
	{"迈克·赛弗斯 | FBI狙击手",							"models/player/custom_player/legacy/ctm_fbi_varianth.mdl"},
	{"“两次”麦考伊 | 美国空军战术空中管制部队",						"models/player/custom_player/legacy/ctm_st6_variantm.mdl"},
	{"第一中尉法洛 | SWAT",						"models/player/custom_player/legacy/ctm_swat_variantf.mdl"},
	{"“两次”麦考伊 | 战术空中管制部队装甲兵",					"models/player/custom_player/legacy/ctm_st6_variantl.mdl"},
};

char TSuperior[][][] =
{
	{"残酷的达里尔（穷鬼）| 专业人士",		"models/player/custom_player/legacy/tm_professional_varf5.mdl"},
	{"精锐捕兽者索尔曼 | 游击队",			"models/player/custom_player/legacy/tm_jungle_raider_varianta.mdl"},
	{"亚诺（野草） | 游击队",				"models/player/custom_player/legacy/tm_jungle_raider_variantc.mdl"},
	{"黑狼 | 军刀",									"models/player/custom_player/legacy/tm_balkan_variantj.mdl"},
	{"沙哈马特教授 | 精锐分子",							"models/player/custom_player/legacy/tm_leet_varianti.mdl"},
	{"准备就绪的列赞 | 军刀",								"models/player/custom_player/legacy/tm_balkan_variantg.mdl"},
	{"老K | 专业人士",						"models/player/custom_player/legacy/tm_professional_vari.mdl"},
	{"飞贼波兹曼 | 专业人士",			"models/player/custom_player/legacy/tm_professional_varg.mdl"},
	{"红衫列赞 | 军刀",							"models/player/custom_player/legacy/tm_balkan_variantk.mdl"},
};

char CTMaster[][][] =
{
	{"中队长鲁沙尔·勒库托 | 法国宪兵特勤队",	"models/player/custom_player/legacy/ctm_gendarmerie_variantc.mdl"},
	{"指挥官弗兰克·巴鲁德（湿袜） | 海豹蛙人",			"models/player/custom_player/legacy/ctm_diver_variantb.mdl"},
	{"指挥官黛维达·费尔南德斯（护目镜） | 海豹蛙人",		"models/player/custom_player/legacy/ctm_diver_varianta.mdl"},
	{"海军上尉里克索尔 | 海军水面战中心海豹部队",					"models/player/custom_player/legacy/ctm_st6_varianti.mdl"},
	{"爱娃特工 | FBI",								"models/player/custom_player/legacy/ctm_fbi_variantb.mdl"},
	{"指挥官 梅 “极寒” 贾米森 | SWAT",				"models/player/custom_player/legacy/ctm_swat_variante.mdl"},
};

char TMaster[][][] =
{
	{"薇帕姐（革新派） | 游击队",	"models/player/custom_player/legacy/tm_jungle_raider_variante.mdl"},
	{"克拉斯沃特（三分熟） | 游击队",		"models/player/custom_player/legacy/tm_jungle_raider_variantb2.mdl"},
	{"遗忘者克拉斯沃特 | 游击队",		"models/player/custom_player/legacy/tm_jungle_raider_variantb.mdl"},
	{"“医生”罗曼诺夫 | 军刀",						"models/player/custom_player/legacy/tm_balkan_varianth.mdl"},
	{"精英穆哈里克先生 | 精锐分子",					"models/player/custom_player/legacy/tm_leet_variantf.mdl"},
	{"残酷的达里尔爵士（迈阿密）| 专业人士",			"models/player/custom_player/legacy/tm_professional_varf.mdl"},
	{"残酷的达里尔爵士（沉默）| 专业人士",		"models/player/custom_player/legacy/tm_professional_varf1.mdl"},
	{"残酷的达里尔爵士（头盖骨）| 专业人士",		"models/player/custom_player/legacy/tm_professional_varf2.mdl"},
	{"残酷的达里尔爵士（皇家）| 专业人士",		"models/player/custom_player/legacy/tm_professional_varf3.mdl"},
	{"残酷的达里尔爵士（聒噪）| 专业人士",		"models/player/custom_player/legacy/tm_professional_varf4.mdl"},
};

#define		DATA	"1.2.0"

public Plugin myinfo =
{
	name		=	"[CS:GO] Franug Agents Chooser",
	author		=	"Franc1sco franug, Romeo, TrueProfessional, Teamkiller324",
	description	=	"Plugin giving you opportunity to change agents",
	version 	=	DATA,
	url			=	"http://steamcommunity.com/id/franug"
}

int		g_iTeam[MAXPLAYERS + 1], g_iCategory[MAXPLAYERS + 1];

char	g_ctAgent[MAXPLAYERS + 1][128], g_tAgent[MAXPLAYERS + 1][128];

Cookie	c_CTAgent, c_TAgent;

ConVar	cv_version, cv_timer, cv_noOverwritte, cv_instant, cv_autoopen, cv_PreviewDuration, cv_HidePlayers;

bool	_checkedMsg[MAXPLAYERS + 1];

public void OnPluginStart()
{
	RegConsoleCmd("sm_agents", Command_Main);
	
	RegAdminCmd("sm_agents_generatemodels", Command_GenerateModelsForSkinchooser, ADMFLAG_ROOT);
	RegAdminCmd("sm_agents_generatestoremodels", Command_GenerateModelsForStore, ADMFLAG_ROOT);
	
	c_CTAgent = new Cookie("CTAgent_b", "", CookieAccess_Private);
	c_TAgent = new Cookie("TAgent_b", "", CookieAccess_Private);
	
	HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("player_team", OnPlayerTeam, EventHookMode_Post);
	
	cv_version			= CreateConVar("sm_csgoagents_version",				DATA,	"Agents Chooser - Version.");
	cv_autoopen			= CreateConVar("sm_csgoagents_autoopen",			"0",	"Agent Chooser - Enable/Disable auto open menu when you connect and you didnt select a agent yet", _, true, 0.0, true, 1.0);
	cv_instant			= CreateConVar("sm_csgoagents_instantly",			"1",	"Agent Chooser - Enable/Disable apply agents skins instantly", _, true, 0.0, true, 1.0);
	cv_timer			= CreateConVar("sm_csgoagents_timer",				"0.2",	"Agent Chooser - Time on Spawn for apply agent skins", _, true, 0.0);
	cv_noOverwritte		= CreateConVar("sm_csgoagents_nooverwrittecustom",	"1",	"Agent Chooser - No apply agent model if the user already have a custom model. \n1 = No apply when custom model \n0 = Disable this feature", _, true, 0.0, true, 1.0);
	cv_PreviewDuration	= CreateConVar("sm_csgoagents_previewduration",		"3.0",	"Agent Chooser - Preview duration when choosing an agent. Disable: 0", _, true, 0.0);
	cv_HidePlayers		= CreateConVar("sm_csgoagents_hideplayers",			"0",	"Agent Chooser - Hide players when thirdperson view active.\nDisable: 0\nEnemies: 1\nAll: 2", _, true, 0.0, true, 2.0);
	
	cv_version.AddChangeHook(VersionCallback);
	cv_HidePlayers.AddChangeHook(OnCvarChange); // use SetTransmit only when is needed
	
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsValidClient(i) && AreClientCookiesCached(i))
		{
			OnClientCookiesCached(i);
		}
	}
	
	AutoExecConfig(true, "csgo_agentschooser");
}

/**
 *	Makes sure the version console variable isn't changed.
 */
void VersionCallback(ConVar cvar, const char[] oldvalue, const char[] newvalue)
{
	cvar.SetString(DATA);
}

void OnCvarChange(ConVar cvar, const char[] oldValue, const char[] newValue)
{
	int iNewValue = StringToInt(newValue);
	int iOldValue = StringToInt(oldValue);
	
	if(iNewValue > 0 && iOldValue == 0)
	{
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsValidClient(i))
			{
				OnClientPutInServer(i);
			}
		}	
	}
	else if(iNewValue == 0 && iOldValue > 0)
	{
		// save cpu usage when we dont want the hideplayers feature
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsValidClient(i))
			{
				SDKUnhook(i, SDKHook_SetTransmit, Hook_SetTransmit);
			}
		}
	}	
}

// I generate these files automatically with code instead of do it manually like a good programmer :p
Action Command_GenerateModelsForSkinchooser(int client, int args)
{
	KeyValues kv = new KeyValues("Models");
	
	kv.JumpToKey("CSGO Agents", true);
	kv.JumpToKey("Team1", true);
	
	for (int i = 0; i < sizeof(TDistinguished); i++)
	{
		kv.JumpToKey(TDistinguished[i][0], true);
		kv.SetString("path", TDistinguished[i][1]);
		kv.GoBack();
	}
	for (int i = 0; i < sizeof(TExceptional); i++)
	{
		kv.JumpToKey(TExceptional[i][0], true);
		kv.SetString("path", TExceptional[i][1]);
		kv.GoBack();
	}
	for (int i = 0; i < sizeof(TSuperior); i++)
	{
		kv.JumpToKey(TSuperior[i][0], true);
		kv.SetString("path", TSuperior[i][1]);
		kv.GoBack();
	}
	for (int i = 0; i < sizeof(TMaster); i++)
	{
		kv.JumpToKey(TMaster[i][0], true);
		kv.SetString("path", TMaster[i][1]);
		kv.GoBack();
	}
	
	kv.GoBack();
	kv.JumpToKey("Team2", true);
	
	for (int i = 0; i < sizeof(CTDistinguished); i++)
	{
		kv.JumpToKey(CTDistinguished[i][0], true);
		kv.SetString("path", CTDistinguished[i][1]);
		kv.GoBack();
	}
	for (int i = 0; i < sizeof(CTExceptional); i++)
	{
		kv.JumpToKey(CTExceptional[i][0], true);
		kv.SetString("path", CTExceptional[i][1]);
		kv.GoBack();
	}
	for (int i = 0; i < sizeof(CTSuperior); i++)
	{
		kv.JumpToKey(CTSuperior[i][0], true);
		kv.SetString("path", CTSuperior[i][1]);
		kv.GoBack();
	}
	for (int i = 0; i < sizeof(CTMaster); i++)
	{
		kv.JumpToKey(CTMaster[i][0], true);
		kv.SetString("path", CTMaster[i][1]);
		kv.GoBack();
	}
	kv.Rewind();
	kv.ExportToFile("addons/sourcemod/configs/sm_skinchooser_withagents.cfg");
	delete kv;
	
	ReplyToCommand(client, "CFG file generated for models.");
	
	return Plugin_Handled;
}

Action Command_GenerateModelsForStore(int client, int args)
{
	char price[32] = "3000"; // default price
	KeyValues kv = new KeyValues("Store");
	
	kv.JumpToKey("CSGO Agents", true);
	kv.JumpToKey("Terrorist", true);
	
	for (int i = 0; i < sizeof(TDistinguished); i++)
	{
		kv.JumpToKey(TDistinguished[i][0], true);
		kv.SetString("model", TDistinguished[i][1]);
		kv.SetString("team", "2");
		kv.SetString("price", price);
		kv.SetString("type", "playerskin");
		kv.GoBack();
	}
	for (int i = 0; i < sizeof(TExceptional); i++)
	{
		kv.JumpToKey(TExceptional[i][0], true);
		kv.SetString("model", TExceptional[i][1]);
		kv.SetString("team", "2");
		kv.SetString("price", price);
		kv.SetString("type", "playerskin");
		kv.GoBack();
	}
	for (int i = 0; i < sizeof(TSuperior); i++)
	{
		kv.JumpToKey(TSuperior[i][0], true);
		kv.SetString("model", TSuperior[i][1]);
		kv.SetString("team", "2");
		kv.SetString("price", price);
		kv.SetString("type", "playerskin");
		kv.GoBack();
	}
	for (int i = 0; i < sizeof(TMaster); i++)
	{
		kv.JumpToKey(TMaster[i][0], true);
		kv.SetString("model", TMaster[i][1]);
		kv.SetString("team", "2");
		kv.SetString("price", price);
		kv.SetString("type", "playerskin");
		kv.GoBack();
	}
	
	kv.GoBack();
	kv.JumpToKey("Counter-Terrorist", true);
	
	for (int i = 0; i < sizeof(CTDistinguished); i++)
	{
		kv.JumpToKey(CTDistinguished[i][0], true);
		kv.SetString("model", CTDistinguished[i][1]);
		kv.SetString("team", "3");
		kv.SetString("price", price);
		kv.SetString("type", "playerskin");
		kv.GoBack();
	}
	for (int i = 0; i < sizeof(CTExceptional); i++)
	{
		kv.JumpToKey(CTExceptional[i][0], true);
		kv.SetString("model", CTExceptional[i][1]);
		kv.SetString("team", "3");
		kv.SetString("price", price); 
		kv.SetString("type", "playerskin");
		kv.GoBack();
	}
	for (int i = 0; i < sizeof(CTSuperior); i++)
	{
		kv.JumpToKey(CTSuperior[i][0], true);
		kv.SetString("model", CTSuperior[i][1]);
		kv.SetString("team", "3");
		kv.SetString("price", price);
		kv.SetString("type", "playerskin");
		kv.GoBack();
	}
	for (int i = 0; i < sizeof(CTMaster); i++)
	{
		kv.JumpToKey(CTMaster[i][0], true);
		kv.SetString("model", CTMaster[i][1]);
		kv.SetString("team", "3");
		kv.SetString("price", price);
		kv.SetString("type", "playerskin");
		kv.GoBack();
	}
	kv.Rewind();
	kv.ExportToFile("addons/sourcemod/configs/storeitems_withagents.txt");
	delete kv;
	
	ReplyToCommand(client, "CFG file generated for models.");
	
	return Plugin_Handled;
}

public void OnClientCookiesCached(int client)
{
	c_CTAgent.Get(client, g_ctAgent[client], 128);
	c_TAgent.Get(client, g_tAgent[client], 128);
}

public void OnClientDisconnect(int client)
{
	if(!IsFakeClient(client) && AreClientCookiesCached(client))
	{
		c_TAgent.Set(client, g_tAgent[client]);
		c_CTAgent.Set(client, g_ctAgent[client]);
	}
	
	strcopy(g_ctAgent[client], 128, "");
	strcopy(g_tAgent[client], 128, "");
	_checkedMsg[client] = false;
	
	if(g_hTimer[client] != null)
	{
		KillTimer(g_hTimer[client]);
		g_hTimer[client] = null;
	}
	
	if(!IsClientSourceTV(client))
	{
		SDKUnhook(client, SDKHook_SetTransmit, Hook_SetTransmit);
	}
}

Action Command_Main(int client, int args)
{
	Menu menu = new Menu(SelectTeam, MenuAction_Select  | MenuAction_End);
	
	menu.SetTitle("请选择你的探员阵营：");
	
	menu.AddItem("", "反恐精英");
	menu.AddItem("", "恐怖分子");
	menu.ExitButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

int SelectTeam(Menu menu, MenuAction action, int client, int selection) 
{
	switch(action)
	{
		case	MenuAction_Select:
		{
			switch(selection)
			{
				case	0:	g_iTeam[client] = CS_TEAM_CT;
				case	1:	g_iTeam[client] = CS_TEAM_T;
			}
			
			OpenAgentsMenu(client);
		}

		case	MenuAction_End:
		{
			delete menu;
		}
	}
}

void OpenAgentsMenu(int client)
{
	Menu menu = new Menu(SelectType, MenuAction_Select  | MenuAction_End);

	menu.SetTitle("请选择探员品质：");
	
	menu.AddItem("", "使用默认探员");
	menu.AddItem("", "高级探员");
	menu.AddItem("", "卓越级探员");
	menu.AddItem("", "非凡级探员");
	menu.AddItem("", "大师级探员");
	
	//SetMenuPagination(menu, MENU_NO_PAGINATION);
	
	menu.ExitBackButton = true;
	menu.Display(client, MENU_TIME_FOREVER);
}

int SelectType(Menu menu, MenuAction action, int client, int selection)
{
	switch(action)
	{
		case	MenuAction_Select:
		{
			switch(selection)
			{
				case	0:
				{
					
					if(IsPlayerAlive(client))
						CS_UpdateClientModel(client);
					
					strcopy(g_ctAgent[client], 128, "");
					strcopy(g_tAgent[client], 128, "");
					
					PrintToChat(client, "您现在尚未使用探员。");
					
					OpenAgentsMenu(client);
				}
				case	1:	DisMenu(client, 0);
				case	2:	ExMenu(client, 0);
				case	3:	SuMenu(client, 0);
				case	4:	MaMenu(client, 0);
			}
			g_iCategory[client] = selection;
		}
		
		case	MenuAction_Cancel, MenuCancel_ExitBack:
		{
 			Command_Main(client, 0);
 		}

		case	MenuAction_End:
		{
			delete menu;
		}
	}
}

void DisMenu(int client, int num)
{
	Menu menu = new Menu(AgentChoosed, MenuAction_Select  | MenuAction_End);
	
	menu.SetTitle("高级探员");
	
	if(g_iTeam[client] == CS_TEAM_CT)
	{
		for(int i = 0; i < sizeof(CTDistinguished); i++)
		{
			menu.AddItem(CTDistinguished[i][1], CTDistinguished[i][0], 
			StrEqual(g_ctAgent[client], CTDistinguished[i][1]) ? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
		}
	}
	else
	{
		for(int i = 0; i < sizeof(TDistinguished); i++)	{
			menu.AddItem(TDistinguished[i][1], TDistinguished[i][0], 
			StrEqual(g_tAgent[client], TDistinguished[i][1]) ? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
		}
	}
	
	menu.ExitBackButton = true;
	menu.DisplayAt(client, num, MENU_TIME_FOREVER);
}

void ExMenu(int client, int num)
{
	Menu menu = new Menu(AgentChoosed, MenuAction_Select  | MenuAction_End);
	
	menu.SetTitle("卓越级探员");
	
	if(g_iTeam[client] == CS_TEAM_CT)
	{
		for(int i = 0; i < sizeof(CTExceptional); i++)
		{
			menu.AddItem(CTExceptional[i][1], CTExceptional[i][0], 
			StrEqual(g_ctAgent[client], CTExceptional[i][1]) ? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
		}
	}
	else
	{
		for(int i = 0; i < sizeof(TExceptional); i++)
		{
			menu.AddItem(TExceptional[i][1], TExceptional[i][0], 
			StrEqual(g_tAgent[client], TExceptional[i][1]) ? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
		}
	}
	
	menu.ExitBackButton = true;
	menu.DisplayAt(client, num, MENU_TIME_FOREVER);
}

void SuMenu(int client, int num)
{
	Menu menu = new Menu(AgentChoosed, MenuAction_Select  | MenuAction_End);
	
	menu.SetTitle("非凡级探员");
	
	if(g_iTeam[client] == CS_TEAM_CT)
	{
		for(int i = 0; i < sizeof(CTSuperior); i++)
		{
			menu.AddItem(CTSuperior[i][1], CTSuperior[i][0], 
			StrEqual(g_ctAgent[client], CTSuperior[i][1]) ? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
		}
	}
	else
	{
		for(int i = 0; i < sizeof(TSuperior); i++)
		{
			menu.AddItem(TSuperior[i][1], TSuperior[i][0], 
			StrEqual(g_tAgent[client], TSuperior[i][1]) ? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
		}	
	}
	
	menu.ExitBackButton = true;
	menu.DisplayAt(client, num, MENU_TIME_FOREVER);
}

void MaMenu(int client, int num)
{
	Menu menu = new Menu(AgentChoosed, MenuAction_Select  | MenuAction_End);
	
	menu.SetTitle("大师级探员");
	
	if(g_iTeam[client] == CS_TEAM_CT)
	{
		for(int i = 0; i < sizeof(CTMaster); i++)
		{
			menu.AddItem(CTMaster[i][1], CTMaster[i][0], 
			StrEqual(g_ctAgent[client], CTMaster[i][1]) ? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
		}
	}
	else
	{
		for(int i = 0; i < sizeof(TMaster); i++)
		{
			menu.AddItem(TMaster[i][1], TMaster[i][0],
			StrEqual(g_tAgent[client], TMaster[i][1]) ? ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
		}
	}
	
	menu.ExitBackButton = true;
	menu.DisplayAt(client, num, MENU_TIME_FOREVER);
}

int AgentChoosed(Menu menu, MenuAction action, any client, int selection)
{
	switch(action)
	{
		case	MenuAction_Select:
		{
			char model[128];
			menu.GetItem(selection, model, sizeof(model));
			
			switch(g_iTeam[client])
			{
				case	CS_TEAM_CT:	strcopy(g_ctAgent[client], 128, model);
				case	CS_TEAM_T:	strcopy(g_tAgent[client], 128, model);
			}
			
			PrintToChat(client, cv_instant.BoolValue ? "探员已选择!":"探员已选择，将在下次重生时生效。");
			
			switch(g_iCategory[client])
			{
				case	1:	DisMenu(client, GetMenuSelectionPosition());
				case	2:	ExMenu(client, GetMenuSelectionPosition());
				case	3:	SuMenu(client, GetMenuSelectionPosition());
				case	4:	MaMenu(client, GetMenuSelectionPosition());
			}
			
			if(cv_instant.BoolValue && IsPlayerAlive(client) && GetClientTeam(client) == g_iTeam[client])
			{
				if(cv_noOverwritte.BoolValue)
				{
					char dmodel[128];
					GetClientModel(client, dmodel, sizeof(dmodel));
					if(StrContains(dmodel, "models/player/custom_player/legacy/") == -1)
					{
						PrintToChat(client, "您已经使用了自定义人物模型，请卸下以使用本插件。");
						return;
					}
				}
				
				SetEntityModel(client, model);
				
				if(cv_PreviewDuration.BoolValue)
				{
					SetThirdPersonMode(client, true);
					
					if(g_hTimer[client] != null)
					{
						KillTimer(g_hTimer[client]);
						g_hTimer[client] = null;
					}
					
					g_hTimer[client] = CreateTimer(cv_PreviewDuration.FloatValue, Timer_SetBackMode, client, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
		case	MenuAction_Cancel, MenuCancel_ExitBack:
 		{
 			OpenAgentsMenu(client);
			
			if(cv_PreviewDuration.BoolValue)
			{
				SetThirdPersonMode(client, false);
				
				if(g_hTimer[client] != null)
				{
					KillTimer(g_hTimer[client]);
					g_hTimer[client] = null;
				}
			}
 		}
		
		case MenuAction_End:
		{
			delete menu;
		}
	}
}

Action Event_PlayerSpawn(Event event, const char[] sName, bool bDontBroadcast)
{
	CreateTimer(cv_timer.FloatValue, Timer_ApplySkin, event.GetInt("userid"));
}

Action Timer_ApplySkin(Handle timer, int id)
{
	int client = GetClientOfUserId(id);
	
	if(id < 1 || !IsValidClient(client) || !IsPlayerAlive(client) || !AreClientCookiesCached(client))
		return;
	
	char model[255];
	switch(GetClientTeam(client))
	{
		case	CS_TEAM_CT:	strcopy(model, sizeof(model), g_ctAgent[client]);
		case	CS_TEAM_T:	strcopy(model, sizeof(model), g_tAgent[client]);
	}	
		
	if(strlen(model) < 1)
	{
		if(cv_autoopen.BoolValue && !_checkedMsg[client])
		{
			_checkedMsg[client] = true;
			Command_Main(client, 0);
		}
		return;
	}
	
	if(!IsModelPrecached(model)) // sqlite corrupted? we restore it
	{
		strcopy(g_ctAgent[client], 128, "");
		strcopy(g_tAgent[client], 128, "");
		return;
	}
	
	if(cv_noOverwritte.BoolValue)
	{
		char dmodel[128];
		GetClientModel(client, dmodel, sizeof(dmodel));
		if(StrContains(dmodel, "models/player/custom_player/legacy/") == -1)
		{
			PrintToChat(client, "您已经使用了自定义人物模型，请卸下以使用本插件。");
			return;
		}
	}
	
	SetEntityModel(client, model);
}

Action Timer_SetBackMode(Handle timer, any client)
{
	SetThirdPersonMode(client, false);
	g_hTimer[client] = null;
}

void SetThirdPersonMode(int client, bool bEnable)
{
	ConVar mp_forcecamera = FindConVar("mp_forcecamera");
	if(mp_forcecamera == null)
	{
		return;
	}
	
	if(bEnable)
	{
		SetEntPropEnt(client, Prop_Send, "m_hObserverTarget", 0); 
		SetEntProp(client, Prop_Send, "m_iObserverMode", 1);
		SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 0);
		SetEntProp(client, Prop_Send, "m_iFOV", 120);
		SendConVarValue(client, mp_forcecamera, "1");
		SetEntProp(client, Prop_Send, "m_iHideHUD", GetEntProp(client, Prop_Send, "m_iHideHUD") | HIDE_RADAR_CSGO);
		SetEntProp(client, Prop_Send, "m_iHideHUD", GetEntProp(client, Prop_Send, "m_iHideHUD") | HIDE_CROSSHAIR_CSGO);
	}
	else
	{
		SetEntPropEnt(client, Prop_Send, "m_hObserverTarget", -1);
		SetEntProp(client, Prop_Send, "m_iObserverMode", 0);
		SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 1);
		SetEntProp(client, Prop_Send, "m_iFOV", 90);
		char sValue[4];
		mp_forcecamera.GetString(sValue, sizeof(sValue));
		SendConVarValue(client, mp_forcecamera, sValue);
		SetEntProp(client, Prop_Send, "m_iHideHUD", GetEntProp(client, Prop_Send, "m_iHideHUD") & ~HIDE_RADAR_CSGO);
		SetEntProp(client, Prop_Send, "m_iHideHUD", GetEntProp(client, Prop_Send, "m_iHideHUD") & ~HIDE_CROSSHAIR_CSGO);
	}
}

public void OnClientPutInServer(int client)
{
	if(!IsClientSourceTV(client))
	{
		SDKHook(client, SDKHook_SetTransmit, Hook_SetTransmit);
	}
}

Action Hook_SetTransmit(int client, int agent)
{
	if(client != agent && g_hTimer[agent] != null)	{
		if(cv_HidePlayers.IntValue == 2)
		{
			return Plugin_Handled;
		}
		else if(g_iTeam[client] != g_iTeam[agent])
		{
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

void OnPlayerTeam(Event event, const char[] name, bool dontBroadcast)
{
	int userid = event.GetInt("userid");
	
	if(userid > 0)
		g_iTeam[GetClientOfUserId(userid)] = event.GetInt("team");
}

stock bool isAgentSelected(int client)
{
	return	(strlen(g_tAgent[client]) < 1 && strlen(g_ctAgent[client]) < 1);
}

bool IsValidClient(int client)
{
	if(client == 0 || client == -1)
		return	false;
	if(client < 1 || client > MaxClients)
		return	false;
	if(!IsClientInGame(client))
		return	false;
	if(!IsClientConnected(client))
		return	false;
	if(IsFakeClient(client))
		return	false;
	if(IsClientReplay(client))
		return	false;
	if(IsClientSourceTV(client))
		return	false;
	
	return	true;
}
