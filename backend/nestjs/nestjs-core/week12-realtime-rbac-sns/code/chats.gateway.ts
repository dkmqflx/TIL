import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  OnGatewayInit,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';

@WebSocketGateway({
  namespace: 'chats',
  cors: { origin: '*' },
})
export class ChatsGateway
  implements OnGatewayInit, OnGatewayConnection, OnGatewayDisconnect
{
  @WebSocketServer()
  server: Server;

  afterInit(server: Server) {
    console.log('ChatsGateway initialized', server);
  }

  handleConnection(client: Socket) {
    console.log(`Client connected: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    console.log(`Client disconnected: ${client.id}`);
  }

  /** 클라이언트가 특정 채팅방에 입장 */
  @SubscribeMessage('enter_chat')
  async enterChat(
    @MessageBody() data: { chatId: number },
    @ConnectedSocket() client: Socket,
  ) {
    const room = `chat-${data.chatId}`;
    await client.join(room);
    client.emit('enter_chat', { message: `방 ${data.chatId}에 입장했습니다.` });
  }

  /** 클라이언트가 메시지 전송 → 해당 Room의 모든 멤버에게 broadcast */
  @SubscribeMessage('send_message')
  async sendMessage(
    @MessageBody() data: { chatId: number; content: string; authorId: number },
    @ConnectedSocket() client: Socket,
  ) {
    const room = `chat-${data.chatId}`;

    // 같은 Room에 있는 모든 소켓(자신 포함)에게 이벤트 emit
    this.server.to(room).emit('receive_message', {
      chatId: data.chatId,
      authorId: data.authorId,
      content: data.content,
      createdAt: new Date().toISOString(),
    });
  }
}
