// Copyright Epic Games, Inc. All Rights Reserved.

#include "AbyssGameMode.h"
#include "AbyssCharacter.h"
#include "UObject/ConstructorHelpers.h"

AAbyssGameMode::AAbyssGameMode()
	: Super()
{
	// set default pawn class to our Blueprinted character
	static ConstructorHelpers::FClassFinder<APawn> PlayerPawnClassFinder(TEXT("/Game/FirstPerson/Blueprints/BP_FirstPersonCharacter"));
	DefaultPawnClass = PlayerPawnClassFinder.Class;

}
