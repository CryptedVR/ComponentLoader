--- SERVICES
local P = game:GetService("Players");

--- MODULE
local M = {};

--- FUNCTIONS
function M.Setup(OnJoin :(Client :Player, Leaving :BindableFunction) -> ())
	--- VARIABLES
	local Registry :{[Player] :BindableFunction} = {};
	
	--- FUNCTIONS
	local function PlayerAdded(Player :Player)
		local LeavingFunction = Instance.new("BindableFunction", script);
		Registry[Player] = LeavingFunction;
		
		OnJoin(Player, LeavingFunction);
	end;
	
	local function PlayerLeaving(Player :Player)
		Registry[Player]:Invoke(); -- Trigger custom leaving function
		Registry[Player]:Destroy(); -- Cleanup
		Registry[Player] = nil; -- Clear the index
		Player:Destroy(); -- Clean up the player object
	end;
	
	--- INITIAL
	for _, Player :Player in P:GetPlayers() do
		task.spawn(PlayerAdded, Player);
	end;
	
	--- EVENTS
	P.PlayerAdded:Connect(PlayerAdded);
	P.PlayerRemoving:Connect(PlayerLeaving);
end;

--- MODULE
return M;
