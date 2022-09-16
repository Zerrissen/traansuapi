--[[
    Made by Zerrissen#5789
    and
    GokuSonModz#7555
]]

local function initLibrary(args)
    local TRaansuAPI = {}
    TRaansuAPI.__index = TRaansuAPI -- Uses a metatable to act as a class

    local GetService = game.GetService;
    local Players = GetService(game, "Players");
    local RunService = GetService(game, "RunService");
    local TweenService = GetService(game, "TweenService");
    local UserInputService = GetService(game, "UserInputService");
    local LocalPlayer = Players.LocalPlayer;

    do
        -- Function that controls the input of GUI settings
        -- THIS WILL BE MUCH MORE CUSTOMIZABLE

        function TRaansuAPI:MakeGUI(args)
            setmetatable(args,{__index={drag=false, rounded=false, size=2, primaryColor=Color3.fromRGB(255, 255, 255), secondaryColor=Color3.fromRGB(255, 255, 255), tertiaryColor=Color3.fromRGB(1, 167, 23), quarternaryColor=Color3.fromRGB(1, 218, 31)}})

            local drag, rounded, size, primaryColor, secondaryColor, tertiaryColor, quarternaryColor =
                args[1] or args.drag,
                args[2] or args.rounded,
                args[3] or args.size,
                args[4] or args.primaryColor,
                args[5] or args.secondaryColor,
                args[6] or args.tertiaryColor,
                args[7] or args.quarternaryColor;

            if drag then
                TRaansuAPI:Draggable(container);
            end;

            if rounded then
                print("Something");
            end;

            if size == 1 then
                local containerSize = UDim2.new(0, 400, 0, 270);
                local containerPos = UDim2.new(0.351, 0, 0.342, 0);
            elseif size == 2 then
                local containerSize = UDim2.new(0, 590, 0, 350);
                local containerPos = UDim2.new(0.28, 0, 0.296, 0);
            else
                local containerSize = UDim2.new(0, 840, 0, 480);
                local containerPos = UDim2.new(0.187, 0, 0.22, 0);
            end;

            local primaryColor = primaryColor or Color3.fromRGB(255, 255, 255); -- Background/Container
            local secondaryColor = secondaryColor or Color3.fromRGB(255, 255, 255); -- Contained Frames/Search bar
            local tertiaryColor = tertiaryColor or Color3.fromRGB(187, 0, 5); -- Accents/gradient 1
            local quarternaryColor = quarternaryColor -- Gradient 2. Leave blank for no gradients
            local gradientColor = ColorSequence.new{ColorSequenceKeypoint.new(0, tertiaryColor), ColorSequenceKeypoint.new(1, quarternaryColor)};

            -- init ScreenGui. Don't enable while building.
            local gui = Instance.new("ScreenGui");
            -- gui.Enabled = false;
            TRaansuAPI.gui = gui;

            -- Create container frame
            local container = TRaansuAPI:CreateObj("Frame", {
                Name = "ContainerFrame";
                Parent = gui;
                Position = containerPos;
                BorderSizePixel = 0;
                BackgroundColor3 = primaryColor;
                Size = containerSize;

                -- Top colored bar, purely aesthetic
                TRaansuAPI:CreateObj("Frame", {
                    Name = "GradientTopBar";
                    BorderSizePixel = 0;
                    Size = gradienttopbarColor; -- MAKE THIS IN SETTINGS
                    Position = UDim2.new(0, 0, 0, 0);
                    TRaansuAPI:CreateObj("UIGradient", {
                        Color = gradientColor;
                    });
                });

                -- Title of GUI. Position won't change (unless I add this in settings)
                TRaansuAPI:CreateObj("TextLabel", {
                    Name = "Title";
                    BackgroundTransparency = 1.000;
                    Position = UDim2.new(0.013, 0, 0.056, 0);
                    Size = UDim2.new(0, 70, 0 , 24);
                    Text = "TRaansu UI";
                    Font = "JosefinSans";
                    TextSize = 14;
                    TRaansuAPI:CreateObj("UIGradient", {
                        Color = gradientColor;
                    });
                });

                -- I believe this is a frame that sits next to the title for tab buttons.
                TRaansuAPI:CreateObj("Frame",{
                    Name = "TabButtonContainer";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Position = tabbuttoncontainerPos; -- MAKE THIS IN SETTINGS
                    Size = tabbuttoncontainerSize; -- MAKE THIS IN SETTINGS
                    TRaansuAPI:CreateObj("UIListLayout", {
                        Padding = UDim.new(0,2);
                        FillDirection = "Horizontal";
                        HorizontalAlignment = "Left";
                        SortOrder = "LayoutOrder";
                        VerticalAlignment = "Top";
                    });
                });

                -- Search icon, sits next to search bar
                TRaansuAPI:CreateObj("ImageLabel", {
                    Name = "SearchIcon";
                    BackgroundTransparency = 1.000;
                    Position = UDim2.new(0.014, 0, 0.157, 0);
                    Size = UDim2.new(0, 24, 0, 24);
                    Image = "http://www.roblox.com/asset/?id=4645651350";
                    BorderSizePixel = 0;
                    TRaansuAPI:CreateObj("UIGradient", {
                        Color = gradientColor;
                        Rotation = 45;
                    });
                });

                -- Search bar, used to search for buttons
                TRaansuAPI:CreateObj("TextBox", {
                    Name = "Searchbar";
                    BackgroundTransparency = 1.000;
                    Position = UDim2.new(0.043, 0, 0.157, 0);
                    Size = searchbarSize; -- MAKE THIS IN SETTINGS
                    Font = Enum.Font.Gotham;
                    BorderSizePixel = 0;
                    PlaceholderText = "Enter function to search";
                    Text = "";
                    TextSize = 14;
                });

                -- Contains the actual tabs (I think)
                TRaansuAPI:CreateObj("Frame", {
                    Name = "ListContainer";
                    Position = UDim2.new(0.015, 0, 0.245, 0);
                    Size = listcontainerSize; -- MAKE THIS IN SETTINGS
                    TRaansuAPI:CreateObj("UIListLayout", {
                        Padding = UDim.new(0, 2);
                        FillDirection = "Horizontal";
                        HorizontalAlignment = "Left";
                        SortOrder = "LayoutOrder";
                        VerticalAlignment = "Top";
                    });
                });
            });

            -- Search function
            container.Searchbar.Changed:Connect(function()
                local search = ContainerFrame.Searchbar.Text:lower();
                if (search ~= "") then
                    for i,v in next, TRaansuAPI.currentTab:GetChildren() do
                        if (not v:IsA("UIPadding") and not v:IsA("UIListLayout")) then
                            local label = v:FindFirstChild("label");
                            local button = v:FindFirstChild("button");
                            local find;
                            if (label and label.Text:gsub("%s", ""):lower():sub(1, #search)) then
                                v.Visible = true;
                                find = true;
                            end;

                            if (button and button:FindFirstChild("label") and button.label.Text:gsub("%s", ""):lower():sub(1, #search) == search) then
                                v.Visible = true;
                                find = true;
                            end;

                            if (not find) then
                                v.Visible = false;
                            end;
                        end;
                    end;
                elseif TRaansuAPI.currentTab then
                    for i,v in next, TRaansuAPI.currentTab:GetChildren() do
                        if(not v:IsA("UIPadding") and not v:IsA("UIListLayout")) then
                            v.Visible = true;
                        end;
                    end;
                end;
                TRaansuAPI.currentTabObject:Update();
            end);
            print("WHAT AM I DOING WRONG")
            -- gui.Enabled = true;
        end;



        -- Function that controls the creation of new GUI children
        function TRaansuAPI:CreateObj(class, data)
            local obj = Instance.new(class);
            for i, v in next, data do
                if i ~= 'Parent' then -- i in this instance is the index of the item
                    if typeof(v) == "Instance" then -- i.e Instance.new() has typeof "Instance"
                        v.Parent = obj;
                    else
                        obj[i] = v; -- Otherwise just make whatever is given
                    end;
                end;
            end;
            obj.Parent = data.Parent; -- Same thing one is just constantly modified
            return obj;
        end;

        -- Function that controls the creation of new tabs
        function TRaansuAPI:CreateTab(name)
            local TabButtonContainer = gui.ContainerFrame.TabButtonContainer;
            -- Buttons?
            local tabSelector = TRaansuAPI:CreateObj("ImageButton", {
                Parent = TabButtonContainer;
                BackgroundTransparency = 1;
                Size = UDim2.new(0, 60, 1, 0); -- MIGHT NEED TO CHANGE IN SETTINGS
                Image = "rbxassetid://4641155773";
                ImageColor3 = Color3.fromRGB(255, 255, 255);
                ScaleType = "Slice";
                SliceCenter = Rect.new(4, 4, 296, 296);
                SliceScale = 1;
                Name = "back";
                TRaansuAPI:CreateObj("UIGradient", {
                    Color = uiSettings.gradientColor;
                });
                TRaansuAPI:CreateObj("TextLabel", {
                    BackgroundTransparency = 1;
                    Text = name;
                    Size = UDim2.new(1, 0, 1, 0);
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                });
            });

            -- Check if button was pushed, if so then change its color and change tab
            local tab = {};
            TabButtonContainer.ChildAdded:Connect(function(Obj)
                tab:Update();
            end);

            if (not TRaansuAPI.currentTab) then
                TRaansuAPI.currentTabSelector = tabSelector;
                TRaansuAPI.currentTab = TabButtonContainer;
                TRaansuAPI.currentTabObject = tab;
                TRaansuAPI.currentTabSelector.ImageColor3 = Color3.fromRGB(150, 150, 150);
                TabButtonContainer.Visible = true;
            else
                TabButtonContainer.Visible = false;
            end;

            tabSelector.MouseButton1Click:Connect(function()
                if (TRaansuAPI.currentSection) then
                    TRaansuAPI.currentTabSelector.ImageColor3 = Color3.fromRGB(255, 255, 255);
                    TRaansuAPI.currentTab.Visible = false;
                end;

                tabSelector.ImageColor3 = Color3.fromRGB(150, 150, 150);
                TabButtonContainer.Visible = true;
                TRaansuAPI.currentTabSelector = tabSelector;
                TRaansuAPI.currentTab = TabButtonContainer;
            end);

            -- I think this is just visual?
            function tab:Update()
                local CanvasSize = UDim2.new(0, 0, 0, 85);
                for i,v in next, TabButtonContainer:GetChildren() do
                    if (not v:IsA("UIListLAyout") and not v:IsA ("UIPadding") and v.Visible) then
                        CanvasSize = CanvasSize + UDim2.new(0, 0, 0, v.AbsoluteSize.Y + 5);
                    end;
                end;

                TRaansuAPI:Tween(TabButtonContainer, {time = 0.1, CanvasSize = CanvasSize});
            end;

            -- Not sure what this is yet......
            function tab:Label(labelName)
                local holder = TRaansuAPI:CreateObj("Frame", {
                    Name = "Placeholder";
                    Parent = TabButtonContainer;
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 0, 0, 350);
                    Size = UDim2.new(1, 0, 1, 0);
                    TRaansuAPI:CreateObj("TextLabel", {
                        Name = "label";
                        BackgroundTransparency = 1;
                        Font = "Gotham";
                        Text = labelName;
                        TextColor3 = Color3.fromRGB(255, 255, 255);
                        TextSize = 12;
                    });
                });
            end;

            -- Toggle the buttons function???
            function tab:Toggle(toggleName, callback)
                local callback = callback or function() end;
                local toggle = false;

                TRaansuAPI.flags[toggleName] = toggle;

            end;
            return tab;
        end;

        -- Function that allows a GUI to be dragged. Applies to all except some objs.
        function TRaansuAPI:Draggable(container)
            local dragging;
            local dragInput;
            local dragStart;
            local startPos;

            local function Update(input)
                local delta = input.Position - dragStart;
                container.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y);
            end;

            container.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true;
                    dragStart = input.Position;
                    startPos = gui.Position;

                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false;
                        end;
                    end);
                end;
            end);

            container.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    dragInput = input;
                end;
            end);

            UserInputService.InputChanged:Connect(function(input)
                if input == dragInput and dragging then
                    Update(input);
                end;
            end);
        end;

    end;
    return TRaansuAPI;
end;

local thing = initLibrary();

thing:MakeGUI{drag=false, size=2, tertiaryColor=Color3.fromRGB(1, 167, 23), quarternaryColor=Color3.fromRGB(1, 218, 31)}

--return initLibrary();
