const DistributedChatSystem = artifacts.require("DistributedChatSystem");

contract("DistributedChatSystem", (accounts) => {
    const [owner, user1, user2] = accounts;

    it("should register a user", async () => {
        const instance = await DistributedChatSystem.deployed();

        const userId = "user1";
        const publicKey = "publicKeyUser1";

        await instance.registerUser(userId, publicKey, { from: user1 });

        const registeredPublicKey = await instance.getUserPublicKey(userId);
        assert.equal(registeredPublicKey, publicKey, "Public key should match");
    });

    it("should create a chat", async () => {
        const instance = await DistributedChatSystem.deployed();

        const chatId = "chat1";
        const userId1 = "user1";
        const publicKey1 = "publicKeyUser1";
        const userId2 = "user2";
        const publicKey2 = "publicKeyUser2";
        const initialMessage = "Hello!";

        await instance.registerUser(userId2, publicKey2, { from: user2 });

        await instance.createChat(chatId, userId1, userId2, initialMessage, { from: user1 });

        const chatInfo = await instance.getChatInfo(chatId);

        assert.equal(chatInfo.participant1, userId1, "Participant1 should match");
        assert.equal(chatInfo.participant2, userId2, "Participant2 should match");
        assert.equal(chatInfo.messageCount.toNumber(), 1, "Initial message count should be 1");
    });

    it("should send a message", async () => {
        const instance = await DistributedChatSystem.deployed();

        const chatId = "chat1";
        const newMessage = "How are you?";
        const senderId = "user1";

        await instance.sendMessage(chatId, newMessage, senderId, { from: user1 });

        const chatInfo = await instance.getChatInfo(chatId);

        assert.equal(chatInfo.messageCount.toNumber(), 2, "Message count should be 2");
    });

    it("should retrieve chat messages", async () => {
        const instance = await DistributedChatSystem.deployed();

        const chatId = "chat1";
        const fromIndex = 0;

        const { messages } = await instance.getChatMessages(chatId, fromIndex);

        assert.equal(messages.length, 2, "There should be 2 messages in the chat");
        assert.equal(messages[0].encryptedContent, "Hello!", "First message content should match");
        assert.equal(messages[1].encryptedContent, "How are you?", "Second message content should match");
    });
});
