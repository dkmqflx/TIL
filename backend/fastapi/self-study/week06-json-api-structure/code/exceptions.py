"""커스텀 예외 클래스.

서비스 계층은 HTTP 를 몰라야 한다(관심사 분리).
그래서 '도메인 예외'만 던지고, HTTP 변환은 main.py 의 전역 핸들러가 맡는다.
"""


class TodoNotFoundError(Exception):
    """요청한 id 의 할 일이 없을 때."""

    def __init__(self, todo_id: int) -> None:
        self.todo_id = todo_id
        super().__init__(f"Todo {todo_id} not found")
