from langchain.agents import create_agent
from langchain.chat_models import init_chat_model
from langchain.tools import tool
from dotenv import load_dotenv

load_dotenv()
llm = init_chat_model(model='openai:kimi-k2')

@tool
def get_current_weather(location: str) -> str:
    """Get the current weather for a given location."""
    # Placeholder implementation
    return f"The current weather in {location} is sunny with a temperature of 25°C."

agent = create_agent(
    model=llm,
    tools=[get_current_weather],
    system_prompt="You are a helpful assistant that provides weather information."
)

if __name__ == "__main__":
    state = agent.invoke({"messages": "how is the weather in New York?"})
    state["messages"][-1].pretty_print()