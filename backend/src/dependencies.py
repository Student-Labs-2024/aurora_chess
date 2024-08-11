from core.factories.chess_player_factory import ChessPlayerFactory
from core.handlers.connection_request_handler import ConnectionRequestHandler
from core.handlers.room_init_request_handler import RoomInitRequestHandler
from core.repository.room_repository.ram_room_repository import RAMRoomRepository
from core.services.message_handler_service import MessageHandlerService
from core.services.room_service import RoomService


message_dispatcher = MessageHandlerService()
rooms_service = RoomService(RAMRoomRepository())
player_session_factory = ChessPlayerFactory()
message_dispatcher.register_handler(
    "roomInitRequest", RoomInitRequestHandler(rooms_service, player_session_factory)
)
message_dispatcher.register_handler(
    "roomConnectionRequest",
    ConnectionRequestHandler(rooms_service, player_session_factory),
)
