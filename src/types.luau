export type Twilight = {
	espObjects: {
		Players: {},
	},
	settings: twilightSettings,
	Instance: {
		PlayerESPs: {
			PlayerESPTracers: {},
		},
		Tracers: {},
	},
	espInstance: any,
	_connections: {},
	unloaded: boolean,
}

export type twilightTheme = {
	boxNeutral: Color3,
	boxSelf: Color3,
	boxTeam: Color3,
	boxEnemy: Color3,

	boxOutlineNeutral: Color3,
	boxOutlineSelf: Color3,
	boxOutlineTeam: Color3,
	boxOutlineEnemy: Color3,

	highlightFillNeutral: Color3,
	highlightFillEnemy: Color3,
	highlightFillTeam: Color3,
	highlightFillSelf: Color3,
	highlightOutline: Color3,

	healthBarFillNeutral: Color3,
	healthBarFillNeutralLow: Color3,
	healthBarFillSelf: Color3,
	healthBarFillSelfLow: Color3,
	healthBarFillTeam: Color3?,
	healthBarFillEnemy: Color3?,
	healthBarFillTeamLow: Color3,
	healthBarFillEnemyLow: Color3,
}

export type twilightSettings = {
	currentColors: twilightTheme,
	healthbarEnabled: boolean,
	healthbarTeamCheck: boolean?,
	boxEnabled: boolean,
	outlineBoxEnabled: boolean?,
	boxTeamCheck: boolean,
	outlineBoxTeamCheck: boolean,
	chamsEnabled: boolean,
	chamsTeamCheck: boolean,
	tracersEnabled: boolean,

	useTeamColor: boolean?, -- sets the esp colors to be based off teams
	limitDistance: number | boolean,
	lowHealthAlert: boolean?,
	showObjectNames: boolean?,

	teamEnabled: boolean,
	enemyEnabled: boolean,
	selfEnabled: boolean,
	neutralEnabled: boolean,
}

export type cham = {
	instance: Instance,
}

export type box = {
	instance: Instance,
}

export type healthbar = {
	instance: Instance,
}

export type espObject = {
	chams: cham,
	espBox: box,
	tracer: Instance,
	healthbar: healthbar,
}

export type playerEsp = {
	instance: espObject,
	boundedTo: Player,
	healthbar: healthbar,
}

export type objectEsp = {
	instance: espObject,
	boundedTo: Instance,
}

return 1
