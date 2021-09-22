local version = "1.0"
local lTokens = { --Local Tokens(Tokes that exist in the programing language) #1
  "output",
  "error",
  "define",
  "importLua",
  "if",
  "declare"
}
local variables = { --All variables are stored here! #4
  'VAR:math.pi="' .. math.pi .. '";',
  'VAR:math.hugeNum=9999999999999999999;',
  'VAR:werl.version="V' .. version .. '";'
}
local sTokens = {} --Session tokens(Potential tokens aka the code you write)
local ifStatemens = {} --All if statements are stored here!
local forLoops = {} --All for loops will be stored here!

--Functions

local function removeParameters(str)
    local newStr = ""
    local b = str:gsub(".", function(c)
        if c == "(" or c == "'" or c == '"' or c == ")" then
        else    
            newStr = newStr .. c
        end
    end)
    return newStr
end

local function removeJunk2(str)
    local newStr = ""
    local b = str:gsub(".", function(c)
        if c == "'" or c == '"' or c == ")" or c == "]" then
        else    
            newStr = newStr .. c
        end
    end)
    return newStr
end

local function removeJunk(str)
    local newStr = ""
    local b = str:gsub(".", function(c)
        if c == "[" or c == " " then
        else    
            newStr = newStr .. c
        end
    end)
    return newStr
end

local function concreteStr(str)
    local newStr = ""
    local b = str:gsub(".", function(c)
        if c == "," or c == "'" or c == '"' then
        else    
            newStr = newStr .. c
        end
    end)
    return '"' .. newStr .. '"'
end

local function splitFunction(str)
    local t = {}
    t[1] = ""
    t[2] = ""
    local splitted = false
    str:gsub(".", function(c)
        if splitted == false then
            if c == "(" then
                splitted = true
            else
                t[1] = t[1] .. c
            end
        else
            t[2] = t[2] .. c
        end
    end)
    return t
end

local function removeDiv(str)
    local t = {}
    t[1] = ""
    t[2] = ""
    local splitted = false
    str:gsub(".", function(c)
        if splitted == false then
            if c == ":" then
                splitted = true
            else
                t[1] = t[1] .. c
            end
        else
            t[2] = t[2] .. c
        end
    end)
    return t
end

local function splitByParameter(str)
    local t = {}
    t[1] = ""
    t[2] = ""
    local splitted = false
    str:gsub(".", function(c)
        if splitted == false then
            if c == "(" then
                splitted = true
            else
                t[1] = t[1] .. c
            end
        else
            t[2] = t[2] .. c
        end
    end)
    return t
end

local function removeAdditionSym(str)
   local t = {}
   t[1] = ""
   t[2] = ""
   local splitted = false
   str:gsub(".", function(c)
       if splitted == false then
           if c == "+" then
               splitted = true
           else
               t[1] = t[1] .. c
           end
       else
           t[2] = t[2] .. c
       end
   end)
   t[1] = tonumber(t[1])
   t[2] = tonumber(t[2])
   return t
end

local function removeSubtractionSym(str)
   local t = {}
   t[1] = ""
   t[2] = ""
   local splitted = false
   str:gsub(".", function(c)
       if splitted == false then
           if c == "-" then
               splitted = true
           else
               t[1] = t[1] .. c
           end
       else
           t[2] = t[2] .. c
       end
   end)
   t[1] = tonumber(t[1])
   t[2] = tonumber(t[2])
   return t
end

local function removeMultiplySym(str)
   local t = {}
   t[1] = ""
   t[2] = ""
   local splitted = false
   str:gsub(".", function(c)
       if splitted == false then
           if c == "*" then
               splitted = true
           else
               t[1] = t[1] .. c
           end
       else
           t[2] = t[2] .. c
       end
   end)
   t[1] = tonumber(t[1])
   t[2] = tonumber(t[2])
   return t
end

local function removeDivisionSym(str)
   local t = {}
   t[1] = ""
   t[2] = ""
   local splitted = false
   str:gsub(".", function(c)
       if splitted == false then
           if c == "/" then
               splitted = true
           else
               t[1] = t[1] .. c
           end
       else
           t[2] = t[2] .. c
       end
   end)
   t[1] = tonumber(t[1])
   t[2] = tonumber(t[2])
   return t
end

local function makeArray(str)
  local t = {}
  local currentWord = ""
  str = str:gsub(", ", ",")
  str:gsub(".", function(c)
  if c == "[" then
  else
      if c == "," or c == "]" then
        table.insert(t, currentWord)
        currentWord = ""
      else
        currentWord = currentWord .. c
      end
    end
  end)
  return t
end

local function SplitVar(str) --I use this function to split variables by name and value and make sure there are no errors!
				local t = {}
        t[1] = ""
        t[2] = ""
        local firstSplit = false
        local secondSplit = false
        str:gsub(".", function(c)
            if firstSplit == false then
                if c == ":" then
                    firstSplit = true
                end
            else
                if c == "=" then
                    firstSplit = false
                    secondSplit = true
                else
                    t[1] = t[1] .. c
                end
            end
            if secondSplit == false then
                if c == "=" then
                    secondSplit = true
                end
            else
                if c == ";" then
                    firstSplit = false
                    secondSplit = false
                else
                    t[2] = t[2] .. c
                end
            end
        end)
        local newT2 = ""
        t[2]:gsub(".", function(c)
            if c == "=" then
            else
                newT2 = newT2 .. c
            end
        end)
        t[2] = newT2
        if not string.find(t[2], '"') and not string.find(t[2], "'") then --Not string! so can do maths
        if string.find(t[2], "+") then
            if not string.find(removeAdditionSym(t[2])[2], "'") or string.find(removeAdditionSym(t[2])[2], '"') then
            t[2] = tostring(removeAdditionSym(t[2])[1] + removeAdditionSym(t[2])[2])
            end
        end
        if string.find(t[2], "-") then
            t[2] = tostring(removeSubtractionSym(t[2])[1] - removeSubtractionSym(t[2])[2])
        end
        if string.find(t[2], "*") then
            t[2] = tostring(removeMultiplySym(t[2])[1] * removeMultiplySym(t[2])[2])
        end
        if string.find(t[2], "/") then
            t[2] = tostring(removeDivisionSym(t[2])[1] / removeDivisionSym(t[2])[2])
        end
        if string.find(t[2], "math.pi") then
            t[2] = tostring(math.pi)
        end

        elseif string.find(t[2], "'") or string.find(t[2], '"') then --Errors!
            if string.find(t[2], "+") then
                print("ERROR: Atempted to concrete a string with a number value!")
                ERROR()
            elseif string.find(t[2], "-") then
                print("ERROR: Atempted to subtract a number value with a string value!")
                ERROR()
            elseif string.find(t[2], "*") then
                print("ERROR: Atempted to multiply a number value with a string value!")
                ERROR()
            elseif string.find(t[2], "/") then
                print("ERROR: Atempted to divide a number value with a string value!")
                ERROR()
            end
        end
        if string.find(t[2], "'") or string.find(t[2], '"') and string.find(t[2], ")") and string.find(t[2], "readF") then
            local threadSubject = splitByParameter(t[2])
            local lThread = io.open(removeParameters(threadSubject[2]), "r")
            t[2] = lThread:read("*a")
            lThread:close()
        end
        --conrete strings
        if not string.find(t[2], "%[") and not string.find(t[2], "%]") and string.find(t[2], ",") then
          t[2] = t[2]:gsub(", ", ",")
          t[2] = concreteStr(t[2])
        end
        --Make arrays from var value
        if string.find(t[2], "%[") and string.find(t[2], "%]") then --array
          array = makeArray(t[2])
        end
        return t
end
table.insert(variables, 'VAR:werl.e.EasterE99="' .. [[2021 suxx. in school XD";]])
local function splitIfStatement(str)
    str = str:gsub("== ", "==")
		str = str:gsub("!= ", "!=")

		if not string.find(str, "==") then
			if string.find(str, "!=") then

			else
				print("ERROR: Unexpected compareing symbol.")
				ERROR()
			end
		end
    local t = {}
    t[1] = ""
    t[2] = ""
    t[3] = ""
    local firstSplit = false
    local secondSplit = false
    local thirdSplit = false
    local debounce = false
    local deb2 = false
    str:gsub(".", function(c)
        if c == "(" and debounce == false then
            firstSplit = true
            debounce = true
        end
        if firstSplit == true then
            if c == "=" then
                firstSplit = false
                secondSplit = true
            else
                if c == "(" then
                else
                    t[1] = t[1] .. c
                end
            end
        end
        if secondSplit == true then
            if c == ")" then
                secondSplit = false
                thirdSplit = true
            else
                if c == "=" then
                else
                    t[2] = t[2] .. c
                end
            end
        end
        if thirdSplit == true then
            if c == ")" and deb2 == false then
                deb2 = true
            else
                if c == "]" then
                    t[3] = t[3] .. c
                    thirdSplit = false
                else
                    t[3] = t[3] .. c
                end
            end
        end
    end)
    return t
end
--<<End of functions>>--

--LLEXER
local Thread = io.open("ballz.werl", "r"):read("*a"):gsub("if", "&if"):gsub("function", "@function")
local words = {}
local currentWord = ""
local isParameter = false
local isVar = false
local isIf = false
Thread:gsub(".", function(c)
        if c == "\n" then
        c = ""
        else
            if isParameter == true then --Making parameters
            if c == ")" then
                table.insert(words, "(" .. currentWord .. ")")
                currentWord = ""
                isParameter = false
            else
                currentWord = currentWord .. c
            end
            elseif isVar == true then --Making vars
                if c == ";" then
                    table.insert(words, "=" .. currentWord .. ";")
                    currentWord = ""
                    isVar = false
                else
                    currentWord = currentWord .. c
                end
            elseif isIf == true then --Making if statements
                if c == "]" then
                    table.insert(ifStatemens, currentWord .. "]")
                    currentWord = ""
                    isIf = false
                else
                    currentWord = currentWord .. c
                end
            else
            if c == " " then
                table.insert(words, currentWord)
                currentWord = ""
            elseif c == "(" then
                table.insert(words, currentWord)
                currentWord = ""
                isParameter = true
            elseif c == "=" then
                table.insert(words, currentWord)
                currentWord = ""
                isVar = true
            elseif c == "&" then
                table.insert(words, currentWord)
                currentWord = ""
                isIf = true
            else
                currentWord = currentWord .. c
            end
            end
        end
end)

local count = 1

local started = false
local var = ""
for i,v in pairs(words) do
    if v == lTokens[3] then --Define
        started = true
        var = "VAR:"
    else
          if started == true then
            if string.find(v, ";") then
                var = var .. v
                started = false
                var = var:gsub("= ", "=")
                if variables[var] then
                else
                  table.insert(variables, var)
                end
                started = false
            else
                var = var .. v
            end
				end
    end
end

--Start of if statement funcs
for i,v in pairs(ifStatemens) do --Adding
        local t = splitIfStatement(v)
        --First Check
        if t[1] == t[2] .. " " then
            local x = splitFunction(t[3])
            table.insert(sTokens, removeJunk(x[1]) .. ":" .. removeJunk2(x[2]))
            break
        end
        --Second Var
        if string.find(t[1], "}") and not string.find(t[1], '"') and not string.find(t[1], "'") then
            for i,v in pairs(variables) do
                t[1] = removeParameters(SplitVar(v)[2])
            end
        end
        --Third Var
      if string.find(t[2], "}") and not string.find(t[2], '"') and not string.find(t[2], "'") then
          for i,v in pairs(variables) do
              t[2] = removeParameters(SplitVar(v)[2])
          end
      end
      if removeParameters(t[1]) == removeParameters(t[2]) then
          local x = splitFunction(t[3])
          table.insert(sTokens, removeJunk(x[1]) .. ":" .. removeJunk2(x[2]))
          break
      end
        local t = splitIfStatement(v)
        --First Check
        if t[1] == t[2] .. " " then
        else    
            local x = splitFunction(t[3])
            table.insert(sTokens, removeJunk(x[1]) .. ":" .. removeJunk2(x[2]))
            break
        end
        --Second Var
        if string.find(t[1], "}") and not string.find(t[1], '"') and not string.find(t[1], "'") then
            for i,v in pairs(variables) do
                t[1] = removeParameters(SplitVar(v)[2])
            end
        end
        if removeParameters(t[1]) == removeParameters(t[2]) then
        else    
            local x = splitFunction(t[3])
            table.insert(sTokens, removeJunk(x[1]) .. ":" .. removeJunk2(x[2]))
            break
        end

        --Third Var
      if string.find(t[2], "}") and not string.find(t[2], '"') and not string.find(t[2], "'") then
          for i,v in pairs(variables) do
              t[2] = removeParameters(SplitVar(v)[2])
          end
      end
      if removeParameters(t[1]) == removeParameters(t[2]) then
      else
          local x = splitFunction(t[3])
          table.insert(sTokens, removeJunk(x[1]) .. ":" .. removeJunk2(x[2]))
          break
    end
end
--End of if statement funcs


--Adding session tokens #2
for i,v in pairs(words) do
    if v == lTokens[1] or v == lTokens[2] or v == lTokens[4] or v == lTokens[6] then
        table.insert(sTokens, v .. ":" .. removeParameters(words[count+1]))
    end
    count = count+1
end

--Running #3
for i,v in pairs(sTokens) do
        local split = removeDiv(v)
        if split[1] == lTokens[1] then --output
        if string.find(split[2], "{") and not string.find(split[2], '"') and not string.find(split[2], "'") then
            for a,b in pairs(variables) do
                if split[2] == "{" .. SplitVar(b)[1] .. "}" then
                    local sV = SplitVar(b)[2]
                    print(removeParameters(sV))
                end
            end
        else
          if not string.find(split[2], "%[") and not string.find(split[2], "%]") and string.find(split[2], ",") then
            split[2] = split[2]:gsub(", ", ",")
            split[2] = concreteStr(split[2])
            print(removeParameters(split[2]))
          else
            print(split[2])
          end
        end
        elseif split[1] == lTokens[2] then --error
        if string.find(split[2], "{") and not string.find(split[2], '"') and not string.find(split[2], "'") then
            for a,b in pairs(variables) do
                if split[2] == "{" .. SplitVar(b)[1] .. "}" then
                    local sV = SplitVar(b)[2]
                    print('\27[31m' .. removeParameters(sV) .. '\27[39m\n')
                end
            end
        else
          if not string.find(split[2], "%[") and not string.find(split[2], "%]") and string.find(split[2], ",") then
            split[2] = split[2]:gsub(", ", ",")
            split[2] = concreteStr(split[2])
            print('\27[31m' .. removeParameters(split[2]) .. '\27[39m\n')
          else
            print('\27[31m' .. split[2] .. '\27[39m\n')
          end
        end
        elseif split[1] == lTokens[4] then --importLua
        if string.find(split[2], "{") and not string.find(split[2], '"') and not string.find(split[2], "'") then
            for a,b in pairs(variables) do
                if split[2] == "{" .. SplitVar(b)[1] .. "}" then
                    local sV = SplitVar(b)[2]
                    local file = removeParameters(sV):gsub(" ", "")
                    require(file)
                end
            end
        else
            require(split[2])
        end
        elseif split[1] == lTokens[6] then
        for a,b in pairs(variables) do
          if split[2] == "{" .. SplitVar(b)[1] .. "}" then
          local sV = SplitVar(b)[2]
          local delcaredVar = removeParameters(sV)
        end
      end
    end
end
