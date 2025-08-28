export type Twilight = {
	espObjects: {}?,
	settings: twilightSettings,
	Instance: Instance,
	_connections: {},
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
	HighlightOutline: Color3,

	healthBarStroke: Color3?,
	healthBarFillNeutral: Color3,
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
	chamsEnabled: boolean,
	chamsTeamCheck: boolean,

	useTeamColor: boolean?, -- sets the esp colors to be based off teams
	limitDistance: number? | boolean,
	lowHealthAlert: boolean?,

	teamEnabled: boolean,
	enemyEnabled: boolean,
	selfEnabled: boolean?,
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
