local CUBIC_GRID_SIZE = 32

local nodeSet = {}

for x = 1, CUBIC_GRID_SIZE do
	nodeSet[x] = {}

	for y = 1, CUBIC_GRID_SIZE do
		nodeSet[x][y] = {}

		for z = 1, CUBIC_GRID_SIZE do			
			nodeSet[x][y][z] = {
				cost = 1,
				f = 0,
				coordinates = Vector3.new(x, y, z),
			}
		end
	end
end

local function pathfind(start: Vector3, destination: Vector3)
	local openSet = {}
	local closedSet = {}

	local path = {} -- empty until path is found
	local costSoFar = {}
	local cameFrom = {}

	local function getNeighbors(coordinates: Vector3)
		return {
			nodeSet[coordinates.X + 1] and nodeSet[coordinates.X + 1][coordinates.Y][coordinates.Z],
			nodeSet[coordinates.X - 1] and nodeSet[coordinates.X - 1][coordinates.Y][coordinates.Z],
			nodeSet[coordinates.X][coordinates.Y + 1] and nodeSet[coordinates.X][coordinates.Y + 1][coordinates.Z],
			nodeSet[coordinates.X][coordinates.Y - 1] and nodeSet[coordinates.X][coordinates.Y - 1][coordinates.Z],
			nodeSet[coordinates.X][coordinates.Y][coordinates.Z + 1],
			nodeSet[coordinates.X][coordinates.Y][coordinates.Z - 1],
		}
	end

	local function putInOpenSet(node, newCost: number)
		node.f = newCost + (node.coordinates - destination).Magnitude

		for i, openNode in openSet do
			if node.f < openNode.f then
				table.insert(openSet, i, node)

				return
			end
		end

		table.insert(openSet, node)
	end

	costSoFar[start] = 0
	openSet[1] = nodeSet[start.X][start.Y][start.Z]

	while #openSet > 0 do
		local current = openSet[1]
		table.remove(openSet, 1)

		if current.coordinates == destination then
			while current.coordinates ~= start do
				table.insert(path, 1, current.coordinates)
				current = cameFrom[current.coordinates]
			end

			return path
		end

		local neighbors = getNeighbors(current.coordinates)

		for _, neighbor in neighbors do
			local newCost = costSoFar[current.coordinates]
				+ nodeSet[neighbor.coordinates.X][neighbor.coordinates.Y][neighbor.coordinates.Z].cost
			
			local neighborCostSoFar = costSoFar[neighbor.coordinates]
			
			if not neighborCostSoFar or newCost < neighborCostSoFar then
				costSoFar[neighbor.coordinates] = newCost
				putInOpenSet(neighbor, newCost)
				cameFrom[neighbor.coordinates] = current
			end
		end
	end

	return path
end
