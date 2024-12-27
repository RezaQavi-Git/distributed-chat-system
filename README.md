## Smart Contract Overview

### Contract: `DistributedChatSystem`

#### Data Structures

1. **User**: Represents a registered user with a `userId` and `publicKey`.
2. **Chat**: Represents a chat session between two participants.
3. **Message**: Represents a message sent within a chat.

#### Mappings

- `users`: Maps a `userId` to a `User`.
- `chats`: Maps a `chatId` to a `Chat`.
- `chatMessages`: Maps a `chatId` to an array of `Message` objects.

#### Events

- `UserRegistered`: Emitted when a user registers.
- `ChatCreated`: Emitted when a chat is created.
- `MessageSent`: Emitted when a message is sent.

#### Key Functions

- `registerUser(string userId, string publicKey)`: Register a new user.
- `createChat(string chatId, string participant1, string participant2, string initialMessage)`: Create a chat.
- `sendMessage(string chatId, string encryptedContent, string senderId)`: Send a message.
- `getUserPublicKey(string userId)`: Retrieve a user's public key.
- `getChatInfo(string chatId)`: Retrieve chat details.
- `getChatMessages(string chatId, uint256 fromIndex)`: Retrieve messages from a chat.

## Testing

The project includes a comprehensive test suite to verify the functionality of the smart contract. Tests are located in the `test/` directory. Run them with:
```bash
truffle test
```

Example tests:
- User registration
- Chat creation
- Message sending and retrieval

## Usage

### Register a User
```solidity
registerUser("user1", "publicKey1");
```

### Create a Chat
```solidity
createChat("chat1", "user1", "user2", "Hello, World!");
```

### Send a Message
```solidity
sendMessage("chat1", "Encrypted Message", "user1");
```

### Retrieve Chat Messages
```solidity
getChatMessages("chat1", 0);
```

## License

This project is licensed under the [MIT License](LICENSE).
