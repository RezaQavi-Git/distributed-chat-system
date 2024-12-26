// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DistributedChatSystem {

    struct User {
        string userId;
        string publicKey;
    }

    struct Message {
        string chatId;
        string encryptedContent;
        string senderId;
        uint256 timestamp;
    }

    struct Chat {
        string participant1;
        string participant2;
        uint256 messageCount;
    }

    /*
        mapping structure of project
        1. map of userId to User data
        2. map of chatId to Chat data
        3. map of messageId to Message data
    */
    mapping(string => User) private users;
    mapping(string => Chat) private chats;
    mapping(string => Message[]) private chatMessages;

    /*
        system events
        1. when user register, we log userId and publicKey in transaction logs
        2. when a chat created, chatId and participantIds log in transaction logs
        3. when a message send, chatId, senderId and timestamp of message logged.
    */
    event UserRegistered(string userId, string publicKey);
    event ChatCreated(string chatId, string participant1, string participant2);
    event MessageSent(string chatId, string senderId, uint256 timestamp);

    /*
        this public method used for register a user with a userId and publicKey
        - user shouldn't already registered in system
    */
    function registerUser(string memory userId, string memory publicKey) public {
        require(bytes(users[userId].userId).length == 0, "User with this userId already registered");
        users[userId] = User({
            userId: userId,
            publicKey: publicKey
        });
        emit UserRegistered(userId, publicKey);
    }

     /*
        this public method used for creation a chat
        - chat shouldn't registered before with this id
        - participants should already registered in system
    */
    function createChat(
        string memory chatId,
        string memory participant1,
        string memory participant2,
        string memory initialMessage
    ) public checkChatExistence checkUserExistence {
        require(bytes(chats[chatId].participant1).length == 0, "Chat already exists");
        require(bytes(users[participant1].userId).length > 0, "Participant1 not registered");
        require(bytes(users[participant2].userId).length > 0, "Participant2 not registered");

        chats[chatId] = Chat({
            participant1: participant1,
            participant2: participant2,
            messageCount: 0
        });

        sendMessage(chatId, initialMessage, participant1);
        emit ChatCreated(chatId, participant1, participant2);
    }

    /*
        this public method used for sending a message
        - chat should already exists in system
        - sender should be one of chat participants
    */
    function sendMessage(
        string memory chatId,
        string memory encryptedContent,
        string memory senderId
    ) public {
        Chat storage chat = chats[chatId];
        require(bytes(chat.participant1).length > 0, "Chat does not exist");
        require(
            keccak256(bytes(senderId)) == keccak256(bytes(chat.participant1)) ||
                keccak256(bytes(senderId)) == keccak256(bytes(chat.participant2)),
            "Sender not a participant"
        );

        chatMessages[chatId].push(Message({
            chatId: chatId,
            encryptedContent: encryptedContent,
            senderId: senderId,
            timestamp: block.timestamp
        }));

        chat.messageCount++;
        emit MessageSent(chatId, senderId, block.timestamp);
    }

    /*
        view method to get publicKey of a user by userId
        - user should already registered
    */
    function getUserPublicKey(string memory userId) public view returns (string memory) {
        require(bytes(users[userId].userId).length > 0, "User not registered");
        return users[userId].publicKey;
    }

    /*
        view method to get chat information(participants, and message counts)
        - chat should already exists
    */
    function getChatInfo(string memory chatId)
        public
        view
        returns (
            string memory participant1,
            string memory participant2,
            uint256 messageCount
        )
    {
        Chat storage chat = chats[chatId];
        require(bytes(chat.participant1).length > 0, "Chat does not exist");
        return (chat.participant1, chat.participant2, chat.messageCount);
    }

    /*
        view method to get a chat messages
        - chat should already exists
        - chat should have minimum fromIndex messages
    */
    function getChatMessages(string memory chatId, uint256 fromIndex)
        public
        view
        returns (Message[] memory messages, uint256 nextIndex)
    {
        Chat storage chat = chats[chatId];
        require(bytes(chat.participant1).length > 0, "Chat does not exist");

        Message[] storage allMessages = chatMessages[chatId];
        require(fromIndex < allMessages.length, "Invalid fromIndex");

        uint256 maxMessages = 10;
        uint256 toIndex = fromIndex + maxMessages > allMessages.length
            ? allMessages.length
            : fromIndex + maxMessages;

        Message[] memory messagesSubset = new Message[](toIndex - fromIndex);
        for (uint256 i = fromIndex; i < toIndex; i++) {
            messagesSubset[i - fromIndex] = allMessages[i];
        }

        return (messagesSubset, toIndex);
    }
}
