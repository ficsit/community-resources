#pragma once

#include "Blueprint/UserWidget.h"
#include "FGWidgetMultiplayer.generated.h"

UCLASS()
class UFGWidgetMultiplayer : public UUserWidget
{
	GENERATED_BODY()
public:
	UPROPERTY(BlueprintReadWrite)
	bool mIsOnline;

	UPROPERTY(BlueprintReadWrite)
	bool mIsPlayingSatisfactory;

	UPROPERTY(BlueprintReadWrite)
	FString mTitle;
};
