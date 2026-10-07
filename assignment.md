# Project 1 Assignment Guide

This guide combines the assignment brief and the grading rubric. It lists the required work and the standard to target for the highest available marks.

## Overview

Complete four questions. The total available score is **15 points**:

| Question | Topic | Points |
|---|---|---:|
| 1 | C program development and compilation | 3 |
| 2 | Transaction processing and control flow | 4 |
| 3 | Functions and recursive problem solving | 4 |
| 4 | Arduino smart parking system | 4 |
| **Total** |  | **15** |

Submit each question's requested code, outputs, explanations, and design evidence. Keep the code readable and make the sample outputs agree with what the code actually does.

---

## Question 1 — C Program Development and Compilation (3 points)

### What to build

Write a C program for a water-quality monitoring device. It receives temperature in degrees Celsius and turbidity in NTU, calculates a simplified water-quality index, classifies the result, and prints a formatted report.

The program must:

1. Declare variables for temperature and turbidity.
2. Calculate the index using:

   ```text
   TemperatureDeviation = abs(Temperature - 25)
   TurbidityPenalty = Turbidity / 2
   Index = 100 - (TemperatureDeviation + TurbidityPenalty)
   ```

3. Classify the water:
   - `Good` when index is at least 80.
   - `Warning` when index is at least 60 and less than 80.
   - `Critical` when index is less than 60.
4. Use at least one user-defined function besides `main()` to perform part of the calculation or classification.
5. Print a formatted monitoring report with both readings, the calculated index, and the status.

### Submit

- Complete C source code.
- Sample output from one test run.
- A short technical explanation covering:
  - **Real-world application:** one real-world use of C in embedded or systems-based applications, and why C suits that application.
  - **Error analysis:** one example of a syntax error and one semantic error that could occur in this program; explain why each is that kind of error.
  - **Compilation lifecycle:** the main stages that transform C source into an executable. State each stage's input and output.

### Highest-mark benchmark — Excellent (more than 2.5 to 3 points)

- The program compiles and correctly performs the required calculations, classification, function use, and formatted output.
- The explanation clearly gives a relevant real-world C application and why C is appropriate.
- Syntax and semantic errors are accurately distinguished using relevant examples. A syntax error violates the language's grammar and is caught during compilation; a semantic error is grammatically valid but expresses incorrect meaning or logic.
- The compilation stages and their inputs and outputs are correct. Cover preprocessing (source plus directives/includes → expanded source), compilation (preprocessed source → assembly), assembly (assembly → object code), and linking (object files/libraries → executable).

---

## Question 2 — Transaction Processing and Control Flow (4 points)

### What to build

Write a repeated-use mobile-money transaction program for one customer's account. It must offer:

1. Deposit — add an amount to the balance.
2. Withdrawal — subtract an amount only when it is positive and the balance is sufficient.
3. Balance inquiry — show the current balance.
4. Transaction summary — show counts of successful deposits and withdrawals.
5. Exit — terminate the program.

The program must:

- Use suitable data types and variables for amounts, balance, transaction counts, and menu choice.
- Use `switch` or `if-else` to handle the selected operation.
- Use a loop so multiple transactions can be processed without restarting.
- Use `continue` to return to the menu when invalid input is detected.
- Use `break` appropriately to terminate a loop or relevant control-flow structure.
- Reject invalid transactions, including negative amounts and withdrawals greater than the available balance. Treat zero amounts as invalid as well, since deposits and withdrawals must be positive.
- Print clear success and rejection messages.
- Keep running until Exit is selected.

### Submit

- Complete C source code.
- Sample input/output showing at least three different menu operations, including one invalid transaction. A strong demonstration can show a successful deposit, an insufficient-funds withdrawal, a balance inquiry, a transaction summary, and Exit.
- A brief explanation of how conditionals, loops, `break`, and `continue` are used.

### Highest-mark benchmark — Excellent (more than 3.5 to 4 points)

- The menu and transaction validation work correctly, and transactions can be repeated until Exit.
- Appropriate data types and conditionals are used.
- A loop supports repeated transactions; `break` and `continue` are both demonstrated correctly.
- Invalid amounts and insufficient balances are handled without changing the balance or increasing successful transaction counts.
- The flow is clear, structured, efficient, and continues until Exit is selected.

---

## Question 3 — Functions and Recursive Problem Solving (4 points)

### What to build

Write a C program that stores delivery distances for **N** routes in an integer array and reports route statistics. Use separate user-defined functions to:

- Calculate the total distance.
- Calculate the average distance.
- Find the longest route.
- Count routes greater than a specified distance limit.

Also implement a recursive function that calculates the sum of the array's distances. The recursive function must have a clear base case, reduce the remaining problem on every call, and return the correct result. Demonstrate function reuse by calling an appropriate function more than once with different arguments, or by using one function as part of another calculation. Display the results clearly.

For the example input `N = 6`, distances `12 25 18 40 15 30`, and limit `20`, the total and recursive sum should both be `140 km`, the average `23.33 km`, the longest route `40 km`, and the count above the limit `3`.

### Submit

- Complete C source code.
- Sample input/output.
- A brief explanation of the function decomposition.
- A brief explanation of recursion and its base case.
- One advantage and one limitation of recursion for this problem.

### Highest-mark benchmark — Excellent (more than 3.5 to 4 points)

- The program is well decomposed into purposeful functions with appropriate parameters and return values.
- Functions are reusable and correctly process the array.
- The recursive sum has a clear base case, reduces the problem each call, and returns the correct result.
- Results and sample output are correct.
- The explanation clearly covers function decomposition, recursion, and one advantage and limitation. For example, recursion can express a shrinking sum cleanly, but uses additional call-stack space compared with an iterative loop.

---

## Question 4 — Arduino-Based Smart Parking System (4 points)

### What to build

Using **Tinkercad Circuits**, design and simulate a parking-space indicator using:

- An Arduino Uno controller.
- An ultrasonic sensor to measure the distance to a vehicle.
- A green LED for an available space.
- A red LED for an occupied space.
- A buzzer that alerts when a vehicle is detected within the chosen distance threshold.

Choose and state an appropriate occupancy threshold. Write Arduino-style C/C++ code that reads the ultrasonic sensor, calculates or determines distance, applies the occupancy condition, and controls both LEDs and the buzzer. Demonstrate that the outputs respond by changing the simulated distance.

The required data flow is:

```text
Ultrasonic Sensor → Arduino Uno → Decision/Processing → LEDs + Buzzer
```

### Submit

- Tinkercad circuit design showing the components and their connections.
- A block diagram of the data flow.
- Arduino source code used in the simulation.
- At least two simulation test cases:
  - Vehicle outside the threshold: green ON, red OFF, buzzer OFF.
  - Vehicle within the threshold: red ON, green OFF, buzzer ON.
- A short explanation of each component's role, how sensor data is processed, and how the Arduino controls the outputs.

### Highest-mark benchmark — Excellent (more than 3.5 to 4 points)

- The Tinkercad circuit correctly integrates the ultrasonic sensor, Arduino Uno, LEDs, and buzzer, with appropriate connections.
- The system operates correctly in simulation: it reads and processes sensor data, applies the stated threshold, and controls the outputs as required.
- The block diagram accurately shows the complete sensor-to-controller-to-actuator data flow.
- Test cases demonstrate the expected responses on both sides of the threshold.

---

## Final submission checklist

- [ ] Question 1: source code, sample run, and all three technical explanation topics.
- [ ] Question 2: source code, sample I/O with at least three operations and an invalid transaction, and control-flow explanation.
- [ ] Question 3: source code, sample I/O, function and recursion explanations, advantage, and limitation.
- [ ] Question 4: Tinkercad circuit, block diagram, source code, two or more simulation tests, and component/data-flow explanation.
- [ ] Outputs match the program's actual behavior and calculations.
- [ ] Code is readable, compiles/runs in the intended environment, and demonstrates the requested constructs.
