import React, { useState } from 'react';
import { Trash2 } from 'lucide-react';

const TodoApp = () => {
  const [todos, setTodos] = useState([
    { id: 1, text: "Õpi Reacti", completed: false },
    { id: 2, text: "Tee süüa", completed: false },
    { id: 3, text: "Mine trenni", completed: false }
  ]);
  const [newTodo, setNewTodo] = useState("");

  // Lisa uus todo
  const addTodo = (e) => {
    e.preventDefault();
    if (newTodo.trim() !== "") {
      setTodos([
        ...todos,
        {
          id: Date.now(),
          text: newTodo,
          completed: false
        }
      ]);
      setNewTodo("");
    }
  };

  // Märgi todo tehtuks/mittetehtuks
  const toggleTodo = (id) => {
    setTodos(todos.map(todo =>
        todo.id === id ? { ...todo, completed: !todo.completed } : todo
    ));
  };

  // Kustuta todo
  const deleteTodo = (id) => {
    setTodos(todos.filter(todo => todo.id !== id));
  };

  return (
      <div className="max-w-md mx-auto mt-10 p-6 bg-white rounded-lg shadow-lg">
        <h1 className="text-2xl font-bold mb-4 text-gray-800">Minu Tegevused</h1>

        {/* Sisestusväli */}
        <form onSubmit={addTodo} className="mb-4 flex gap-2">
          <input
              type="text"
              value={newTodo}
              onChange={(e) => setNewTodo(e.target.value)}
              placeholder="Lisa uus tegevus..."
              className="flex-1 p-2 border rounded"
          />
          <button
              type="submit"
              className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
          >
            Lisa
          </button>
        </form>

        {/* Todo list */}
        <ul className="space-y-2">
          {todos.map(todo => (
              <li
                  key={todo.id}
                  className="flex items-center justify-between p-3 bg-gray-50 rounded hover:bg-gray-100"
              >
                <div className="flex items-center gap-2">
                  <input
                      type="checkbox"
                      checked={todo.completed}
                      onChange={() => toggleTodo(todo.id)}
                      className="w-4 h-4"
                  />
                  <span className={todo.completed ? "line-through text-gray-500" : ""}>
                {todo.text}
              </span>
                </div>
                <button
                    onClick={() => deleteTodo(todo.id)}
                    className="text-red-500 hover:text-red-700"
                >
                  <Trash2 size={18} />
                </button>
              </li>
          ))}
        </ul>
      </div>
  );
};

export default TodoApp;