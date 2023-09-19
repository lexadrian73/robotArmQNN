s_      = 10.0 + (255 - 10) * rand();
state   = [s_, 0.0, 0.0];

%Agent
agent.speedA       = 30;
agent.speedB       = 30;
agent.angleA       = 45;
agent.angleB       = 40;
agent.limit_angleA = [0, 150];  %Degrees
agent.limit_angleB = [0, 210];  %Degrees

actions = [2, 2, 2, 2, 2, 4, 4, 4, 8, 6, 2, 4];
num_actions = 12;
a = 0;

valuesA    = [0, 45, 90, 135];
toleranceA = 10;
valuesB    = [0, 40, 80, 120, 160, 200];
toleranceB = 10;


while a <= num_actions
    a = a + 1;
    for i = 1:length(actions)
        possible_actions_array = possibleActions(state, agent);
        new_state = action_env(actions(i), state, agent);
        new_state(2) = estimatedValue(new_state(2), valuesA, toleranceA);
        new_state(3) = estimatedValue(new_state(3), valuesB, toleranceB);
        reward       = rewardRobot_s(state(1), new_state(1));
        fprintf("state %s, new_state %s, reward %f\n", num2str(state), num2str(new_state), reward)
        state     = new_state;
    end
end