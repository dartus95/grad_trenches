#include "script_component.hpp"
/*
* Author: nomisum
* Spawns a Trench local to Server
*
* Arguments:
* 0: TrenchClass <STRING>
* 1: PosDiff <NUMBER 0-1>
* 2: Pos <ARRAY>
* 3: VecDirAndUp <NESTED ARRAY>
*
* Return Value:
* None
*
* Example:
* [TrenchObj, 0.5] call grad_trenches_functions_fnc_setTrenchProgress
*
* Public: No
*/

params ["_trenchClass", "_posDiff", "_pos", "_vecDirAndUp"];

//Create a new trench, that is globally visible
private _trench = createVehicle [_trenchClass, [0,0,0], [], 0, "CAN_COLLIDE"];
private _digTime = missionNamespace getVariable [getText (configFile >> "CfgVehicles" >> _trenchClass >>"ace_trenches_diggingDuration"), 20];

_trench setObjectTextureGlobal [0, surfaceTexture _pos];

_trench setVariable [QGVAR(diggingSteps), (_posDiff/(_digTime*10)), true];
if (GVAR(createTrenchMarker)) then {[_trench, side group _unit] call FUNC(createTrenchMarker)};

[_trench, 0] call FUNC(setTrenchProgress); // animate to down under initially

_trench setVectorDirAndUp _vecDirAndUp; 
_pos set [2, 0]; // trench can only sit on zero, rest is done by animation
_trench setPosATL _pos; // prevent glitches by setting position last, prepare on 0,0,0 - move - rest is done by animation
_trench setVariable ["ace_trenches_progress", 0, true];

[QGVAR(addTrenchToDecay), [_trench, GVAR(timeoutToDecay), GVAR(decayTime)]] call CBA_fnc_serverEvent;

[_trench, _unit, false] call FUNC(continueDiggingTrench);