Config = {}

Config.CommandName = 'referral'

Config.NotificationType = 'ox_lib' -- ox_lib, framework, okokNotify

Config.DiscordWebhooks = {
    claim = 'https://discord.com/api/webhooks/1305189046687105084/QWNLuWhpiHH3wLv6swZ4mJizbfBjxGp3Vwye56CqZesURDSd1tumdEtAb2xNK1xUYq1d', -- Logs when the player claims someone's code
    create_code = 'https://discord.com/api/webhooks/1305188922610946140/9YRAHuFviylgTP-Q3M-A0Dqzt1mtUR5fMyJQORkYp418mNf_Es0EaD1fQam8-rnQgQEM', -- Logs when the player creates a new referral code
    claim_rewards = 'https://discord.com/api/webhooks/1305188951224750081/6YZtK0-fLJZmSocu0IQ-tLkOtyzFMqVk7eFuQH4P4wHv4zRWDj_MDD7-PxFZncT9r2J9' -- Logs when the player claims his rewards from other people using his code
}

Config.MoneyAmount = {
    redeem = 1000, -- This is the amount youget when you use someone's code
    receive = 1000 -- This is the amount you get when someone uses your code
}