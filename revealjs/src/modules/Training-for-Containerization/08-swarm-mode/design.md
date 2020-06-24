# Intro to Swarm

Time allocation: 3 hours

## Learning Objectives

Learners will be able to

 - Set up a Swarm
 - Deploy containers as a Swarm service
 - Limit container compute resource consumption
 - Manipulate scheduling decisions using scheduling modes and label constraints
 - Provision configuration to services via Swarm secrets and configs
 - Perform rolling updates and rollback of Swarm services
 - Configure and build for stateful, stateless, internal and external routing to Swarm services
 - Describe and deploy an entire application as a Docker Stack
 - Identify the three Swarm networking planes, and describe the best practices with respect to each

## Assignment: Lab Exercises

### 1. Creating a Swarm (15 min)

 - Create a swarm in high availability mode
 - Set default address pools
 - Check necessary connectivity between swarm nodes
 - Configure the swarm's TLS certificate rotation

### 2. Starting a Service (10 min)

 - Schedule a docker service across a swarm
 - Predict and understand the scoping behavior of docker overlay networks
 - Scale a service on swarm up or down

### 3. Node Failure Recovery (10 min)

 - Anticipate swarm scheduling decisions when nodes fail and recover
 - Force swarm to reallocate workload across a swarm

### 4. Swarm Scheduling (30 minutes)

 - Impose CPU and memory resource allocations and limitations; observe consequences
 - Global vs replicated scheduling
 - Topology aware scheduling
 - Node constraints

### 5. Provisioning Config (20 minutes)

 - Provision some non-secure config to a service using env files and docker configs
 - Provision secure config using secrets
 - Describe application as a stack

### 6. Routing to Services (20 minutes)

 - Deploy and investigate standard VIP routing
 - Deploy and investigate service mesh routing

### 7. Updating Applications (20 minutes)

 - identify bottlenecks in dockercoins and scale past them
 - Configure and perform rolling update of service
 - Configure and perform rollback of service update


## Instructional Material

 - Lecture (slides): 60 min

   - Discussion: What does the portability of containers imply for managing a datacenter?
     - That it can and should be highly automated; containers should 'just run' anywhere
     - That we can treat a datacenter more like a pool of compute resources, and less like a bunch of individual machines.
   - Learning objectives
   - Orchestrator goals
     - Treat clusters like a pool of resources.
     - Must be able to add new compute resources
     - Must be able to schedule and maintain containers across the cluster
     - Must be able to support communication between all these scalable components
   - Networking planes: goals
   - Networking planes: implementation
   - Services: definition
   - Services vs tasks vs containers: jargon
   - Demo: self-healing swarm
   - Exercises: Creating a Swarm; Starting a Service; Node Failure Recovery
   - Pets v Livestock
   - Scheduling
     - CPU + memory constraints and catastrophes
     - Label constraints and topologies
     - replicated v. global
   - Exercises: Swarm Scheduling
   - Configuration: needs to be modular
     - .env files
     - docker configs
     - docker secrets
   - Stacks: definition
   - Exercises: Provisioning Config
   - Swarm routing
     - DNS resolution
     - rr behavior (internal VIPs and external mesh)
   - Exercises: Routing to Services
   - Application management
     - component scalability
     - rolling updates & rollback
   - Exercises: Updating Applications
