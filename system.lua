local self = {}

self.buildCores = math.floor(tonumber(io.popen('nproc', 'r'):read('*l')) / 1.5)

return self
